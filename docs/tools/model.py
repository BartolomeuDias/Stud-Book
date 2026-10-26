# -*- coding: utf-8 -*-
"""Расчётная модель: сеть оставшихся работ (CPM/PERT) и выравнивание ресурсов."""
import math
from collections import OrderedDict
from datetime import datetime, timedelta

import inputs as I

PK = OrderedDict((p["id"], p) for p in I.PACKAGES)
EPS = 1e-9


# --- календарь -------------------------------------------------------------
def _calendar(n=300):
    out, d = [], I.T0
    while len(out) < n:
        if d.weekday() < 5 and d not in I.HOLIDAYS:
            out.append(d)
        d += timedelta(days=1)
    return out


CAL = _calendar()


def day_index(d):
    """Сколько рабочих дней прошло от t=0 к концу календарного дня d."""
    return sum(1 for x in CAL if x <= d)


T_ACC = day_index(I.LAST_WORKDAY_BEFORE_FINAL)   # 49: готовность к финальной приёмке
T_CLOSE = day_index(I.CLOSE_BY)                  # 53: закрытие проекта
MILESTONES = [(code, dt, day_index(dt), text) for code, dt, text in I.PAIRS]


def rnd(x):
    return int(math.floor(x + 0.5))


def start_date(s):
    return CAL[rnd(s)]


def finish_date(s, f):
    return CAL[max(rnd(f) - 1, rnd(s))]


def x_start(t):
    i = int(math.floor(t + EPS))
    return datetime.combine(CAL[i], datetime.min.time()) + timedelta(days=t - i)


def x_end(t):
    i = max(int(math.ceil(t - EPS)) - 1, 0)
    return datetime.combine(CAL[i], datetime.min.time()) + timedelta(days=t - i)


def weeks(t_end=None):
    """Недели [(понедельник, i0, i1)] в индексах рабочих дней."""
    t_end = T_CLOSE if t_end is None else t_end
    out = []
    for i in range(t_end):
        mon = CAL[i] - timedelta(days=CAL[i].weekday())
        if out and out[-1][0] == mon:
            out[-1][2] = i + 1
        else:
            out.append([mon, i, i + 1])
    return [tuple(w) for w in out]


# --- оценки ----------------------------------------------------------------
def E(pid):
    p = PK[pid]
    return (p["o"] + 4 * p["m"] + p["p"]) / 6.0


def sigma_h(pid):
    p = PK[pid]
    return (p["p"] - p["o"]) / 6.0


def E_rem(pid):
    return E(pid) * (1 - PK[pid]["done"])


def E_done(pid):
    return E(pid) * PK[pid]["done"]


def sigma_rem(pid):
    return sigma_h(pid) * (1 - PK[pid]["done"])


def phi(z):
    return 0.5 * (1.0 + math.erf(z / math.sqrt(2.0)))


def done_hours():
    """Часы выполненной части по людям (делятся пропорционально часам устава)."""
    out = {}
    for pid, p in PK.items():
        if p["done"] <= 0:
            continue
        tot = sum(I.PEOPLE[x]["h"] for x in p["team_done"])
        out[pid] = {x: E_done(pid) * I.PEOPLE[x]["h"] / tot for x in p["team_done"]}
    return out


def cost(hmap):
    return sum(h * I.PEOPLE[x]["rate"] for x, h in hmap.items())


class Plan:
    def __init__(self, key, title, extra, cut, team_override=None):
        self.key, self.title, self.extra = key, title, extra
        self.hours = I.hours(extra)
        self.reserve = I.reserve(extra)
        self.week_h = sum(self.hours.values())
        self.cut = set(cut)
        self.team = {pid: list(PK[pid]["team"]) for pid in PK}
        self.team.update(team_override or {})
        self.disc = [pid for pid in PK if PK[pid]["kind"] == "disc" and pid not in self.cut]
        self.loe = [pid for pid in PK if PK[pid]["kind"] == "loe" and pid not in self.cut]
        self.scope = [pid for pid in PK if pid not in self.cut]
        self.preds = {pid: [q for q in PK[pid]["preds"] if q in self.disc] for pid in self.disc}
        self.succ = {pid: [] for pid in self.disc}
        for pid in self.disc:
            for q in self.preds[pid]:
                self.succ[q].append(pid)
        for pid in self.disc:   # всё, что не имеет последователей, сдаётся на финальной приёмке
            if not self.succ[pid] and pid not in ("6.3", "1.4"):
                self.preds["6.3"].append(pid)
                self.succ[pid].append("6.3")
        self.warnings = []
        self._cpm()
        self._level()
        self._loe()
        self._hours()
        self._chains()

    # --- мощность и длительности ---
    def cap(self, person, pid=None):
        h = self.hours[person]
        if pid != "1.4":            # после приёмки гамаки закончены — полный фонд
            h -= self.reserve.get(person, 0)
        return h / 5.0

    def power(self, pid):
        return sum(self.cap(x, pid) for x in self.team[pid])

    def dur(self, pid):
        return E_rem(pid) / self.power(pid)

    def sig_d(self, pid):
        return sigma_rem(pid) / self.power(pid)

    # --- сеть ---
    def _cpm(self):
        ES, EF, todo = {}, {}, list(self.disc)
        while todo:
            for pid in list(todo):
                if all(q in EF for q in self.preds[pid]):
                    ES[pid] = max([EF[q] for q in self.preds[pid]], default=0.0)
                    EF[pid] = ES[pid] + self.dur(pid)
                    todo.remove(pid)
        T = EF["1.4"]
        LS, LF, todo = {}, {}, list(self.disc)
        while todo:
            for pid in list(todo):
                if all(q in LS for q in self.succ[pid]):
                    LF[pid] = min([LS[q] for q in self.succ[pid]], default=T)
                    LS[pid] = LF[pid] - self.dur(pid)
                    todo.remove(pid)
        self.ES, self.EF, self.LS, self.LF, self.T = ES, EF, LS, LF, T
        self.TF = {p: LS[p] - ES[p] for p in self.disc}
        self.FF, self.IF = {}, {}
        for p in self.disc:
            nxt = min([ES[q] for q in self.succ[p]], default=LF[p])
            prv = max([LF[q] for q in self.preds[p]], default=0.0)
            self.FF[p] = nxt - EF[p]
            self.IF[p] = max(0.0, nxt - prv - self.dur(p))
        self.critical = [p for p in self.disc if abs(self.TF[p]) < 1e-6]
        path, node = ["1.4"], "1.4"
        while self.preds[node]:
            node = max(self.preds[node], key=lambda q: (EF[q], -self.TF[q]))
            path.append(node)
        self.crit_path = path[::-1]                       # до закрытия 1.4
        self.crit_to_acc = [p for p in self.crit_path if p != "1.4"]   # до конца 6.3
        self.T_net = EF["6.3"]
        self.sigma_net = math.sqrt(sum(self.sig_d(p) ** 2 for p in self.crit_to_acc))
        self.p_net = phi((T_ACC - self.T_net) / self.sigma_net)

    # --- выравнивание: serial SGS, один человек — один пакет, приоритет по позднему началу ---
    def _level(self):
        order = sorted(self.disc, key=lambda p: (self.LS[p], self.TF[p], p))
        busy = {x: [] for x in I.ALL}
        S, F, placed, pending = {}, {}, set(), list(order)
        self.block = {}
        while pending:
            pid = next(p for p in pending if all(q in placed for q in self.preds[p]))
            pending.remove(pid)
            d = self.dur(pid)
            ready = max([F[q] for q in self.preds[pid]], default=0.0)
            t, blockers = ready, []
            while True:
                clash = [(b, x, other) for x in self.team[pid] for (a, b, other) in busy[x]
                         if a < t + d - EPS and b > t + EPS]
                if not clash:
                    break
                t = max(c[0] for c in clash)
                blockers = [(x, other) for (b, x, other) in clash if abs(b - t) < 1e-6]
            S[pid], F[pid] = t, t + d
            self.block[pid] = (ready, blockers)
            for x in self.team[pid]:
                busy[x].append((t, t + d, pid))
            placed.add(pid)
        # закрытие — после финальной пары (26.12), не раньше
        if F["6.3"] < T_ACC:
            for x in self.team["1.4"]:
                busy[x] = [iv for iv in busy[x] if iv[2] != "1.4"]
                busy[x].append((float(T_ACC), T_ACC + self.dur("1.4"), "1.4"))
            S["1.4"], F["1.4"] = float(T_ACC), T_ACC + self.dur("1.4")
        self.S, self.F, self.busy = S, F, busy
        self.T_sched = F["6.3"]
        self.buffer = T_ACC - self.T_sched

    def _anchor(self, a, S, acc):
        if a == 0:
            return 0.0
        if a == "ACC":
            return acc
        return S[a.split(":")[1]]

    def _loe(self):
        self.win, self.win_net = {}, {}
        for pid in self.loe:
            spec = I.LOE[pid]
            self.win[pid] = (self._anchor(spec["start"], self.S, max(self.F["6.3"], T_ACC)),
                             self._anchor(spec["end"], self.S, max(self.F["6.3"], T_ACC)))
            self.win_net[pid] = (self._anchor(spec["start"], self.ES, self.ES["1.4"]),
                                 self._anchor(spec["end"], self.ES, self.ES["1.4"]))

    def _loe_rates(self, pid, win, warn=False):
        """Часы в день по людям для гамака в окне win."""
        spec, length = I.LOE[pid], win[1] - win[0]
        rate = E_rem(pid) / length
        lead_cap = self.hours[spec["lead"]] / 5.0 if pid == "6.2" else self.reserve[spec["lead"]] / 5.0
        lead = min(rate, lead_cap)
        out = {spec["lead"]: lead}
        if rate - lead > 1e-9:
            helper = spec["helper"]
            if warn and (helper is None or rate - lead > self.reserve.get(helper, 0) / 5.0 + 1e-9):
                self.warnings.append("%s: гамаку не хватает резерва часов (%.2f ч/дн сверх)" % (pid, rate - lead))
            out[helper or spec["lead"]] = out.get(helper or spec["lead"], 0) + rate - lead
        return out

    # --- часы и стоимость ---
    def _hours(self):
        H = OrderedDict()
        for pid in self.scope:
            kind = PK[pid]["kind"]
            if kind == "disc":
                H[pid] = {x: self.dur(pid) * self.cap(x, pid) for x in self.team[pid]}
            elif kind == "loe":
                length = self.win[pid][1] - self.win[pid][0]
                H[pid] = {x: r * length for x, r in self._loe_rates(pid, self.win[pid], warn=True).items()}
            else:
                H[pid] = {}
        self.H = H
        self.H_done = done_hours()
        self.rem_h = sum(E_rem(p) for p in self.scope)
        self.done_h = sum(E_done(p) for p in PK)
        self.cost_rem = sum(cost(h) for h in H.values())
        self.cost_done = sum(cost(h) for h in self.H_done.values())
        self.bac = self.cost_rem + self.cost_done
        self.fund_rem = T_CLOSE * self.week_h / 5.0

    def pkg_cost(self, pid):
        return cost(self.H.get(pid, {})) + cost(self.H_done.get(pid, {}))

    def person_hours(self, x):
        return sum(h.get(x, 0) for h in self.H.values())

    # --- загрузка по неделям ---
    def load(self, leveled=True):
        S, F = (self.S, self.F) if leveled else (self.ES, self.EF)
        win = self.win if leveled else self.win_net
        wk = weeks(max(T_CLOSE, int(math.ceil(max(F.values())))))
        out = {x: [0.0] * len(wk) for x in I.ALL}
        for pid in self.disc:
            for x in self.team[pid]:
                for k, (_, i0, i1) in enumerate(wk):
                    ov = min(F[pid], i1) - max(S[pid], i0)
                    if ov > 0:
                        out[x][k] += ov * self.cap(x, pid)
        for pid in self.loe:
            for x, r in self._loe_rates(pid, win[pid]).items():
                for k, (_, i0, i1) in enumerate(wk):
                    ov = min(win[pid][1], i1) - max(win[pid][0], i0)
                    if ov > 0:
                        out[x][k] += ov * r
        cap = {x: [(i1 - i0) * self.hours[x] / 5.0 for (_, i0, i1) in wk] for x in I.ALL}
        return wk, out, cap

    # --- плановый объём нарастающим итогом ---
    def pv(self, t):
        hours, usd = self.done_h, self.cost_done
        for pid in self.scope:
            kind = PK[pid]["kind"]
            if kind == "disc":
                a, b = self.S[pid], self.F[pid]
            elif kind == "loe":
                a, b = self.win[pid]
            else:
                continue
            share = min(1.0, max(0.0, (t - a) / (b - a)))
            hours += share * E_rem(pid)
            usd += share * cost(self.H[pid])
        return hours, usd

    # --- критическая цепочка с учётом ресурсов и вероятность по расписанию ---
    def _chains(self):
        chain, node = ["6.3"], "6.3"
        while self.S[node] > 1e-6:
            cands = [q for q in self.disc if q != node and abs(self.F[q] - self.S[node]) < 1e-6
                     and (q in self.preds[node] or set(self.team[q]) & set(self.team[node]))]
            if not cands:
                break
            node = max(cands, key=lambda q: (q in self.preds[node], self.dur(q)))
            chain.append(node)
        self.res_chain = chain[::-1]
        self.sigma_sched = math.sqrt(sum(self.sig_d(p) ** 2 for p in self.res_chain))
        self.p_sched = phi((T_ACC - self.T_sched) / self.sigma_sched)

    def waited_for(self, pid):
        """Кто из исполнителей и каким пакетом был занят, пока работа ждала старта."""
        ready, out = self.block[pid][0], OrderedDict()
        for x in self.team[pid]:
            for a, b, other in sorted(self.busy[x]):
                if other != pid and a < self.S[pid] - 1e-6 and b > ready + 1e-6:
                    out.setdefault(other, [])
                    if x not in out[other]:
                        out[other].append(x)
        return out

    def milestone(self, pid):
        """Первая пара, к которой пакет готов по расписанию."""
        for code, dt, t, _ in MILESTONES:
            if self.F[pid] <= t + 1e-6:
                return code
        return "после В4"
