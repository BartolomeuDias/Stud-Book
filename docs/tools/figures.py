# -*- coding: utf-8 -*-
"""Рисунки: сетевой график, диаграмма Ганта, загрузка ресурсов."""
import os
from datetime import datetime, timedelta

import matplotlib

matplotlib.use("Agg")
import matplotlib.dates as mdates
import matplotlib.pyplot as plt
from matplotlib import font_manager
from matplotlib.lines import Line2D
from matplotlib.patches import FancyBboxPatch, Patch, Rectangle

import inputs as I
import model as M

INK, MUTED, GRID = "#000000", "#7f7f7f", "#d9d9d9"
BAR, RED, LOE, BUF = "#7f7f7f", "#c00000", "#d9d9d9", "#ffe699"
BRANCH = {"1": "1. Управление проектом", "2": "2. Анализ, проектирование и подготовка", "3": "3. Учёт лошадей и справки",
          "4": "4. Планирование случной деятельности", "5": "5. Клиенты и финансы", "6": "6. Интеграция, тестирование и приёмка"}
_OFFICE_FONTS = "/Applications/Microsoft Word.app/Contents/Resources/DFonts"


def setup():
    family = ["Arial", "Helvetica Neue", "DejaVu Sans"]
    if os.path.exists(os.path.join(_OFFICE_FONTS, "Calibri.ttf")):
        for f in ("Calibri.ttf", "Calibrib.ttf", "Calibrii.ttf"):
            path = os.path.join(_OFFICE_FONTS, f)
            if os.path.exists(path):
                font_manager.fontManager.addfont(path)
        family.insert(0, "Calibri")
    plt.rcParams.update({
        "font.family": "sans-serif", "font.sans-serif": family,
        "axes.unicode_minus": False, "figure.facecolor": "white", "axes.facecolor": "white",
        "savefig.facecolor": "white", "savefig.dpi": 170, "text.color": INK, "axes.edgecolor": INK,
        "axes.labelcolor": INK, "xtick.color": INK, "ytick.color": INK, "hatch.linewidth": 0.5,
    })


def ru(x, n=1):
    x = 0.0 if abs(x) < 0.5 * 10 ** (-n) else x
    return ("%.*f" % (n, x)).replace(".", ",")


def surname(code):
    return I.PEOPLE[code]["name"].split()[0]


# ---------------------------------------------------------------------------
# Сетевой график
# ---------------------------------------------------------------------------
POS = {  # (колонка, строка)
    "1.1": (0, 3.4),
    "2.4": (1, 1.0), "2.2": (1, 2.2), "2.3": (1, 3.4), "1.2": (1, 4.6), "4.1": (1, 5.8),
    "6.1": (2.25, 0.0), "2.5": (2.1, 1.6),
    "3.1": (3.2, 2.8),
    "3.2": (4.3, 1.6), "3.3": (4.3, 2.8),
    "3.5": (5.4, 1.6), "3.4": (5.4, 2.8), "5.1": (5.4, 4.3), "4.2": (5.4, 5.8),
    "6.4": (6.5, 2.2), "6.3": (7.6, 3.4), "1.4": (8.7, 3.4),
}
CUT_POS = {"4.3": (4.3, 7.45), "5.2": (5.4, 7.45), "5.3": (6.5, 7.45), "5.4": (7.6, 7.45)}
KX, KY, BW, BH = 3.45, 1.5, 2.95, 1.06
ELBOW = {("6.1", "6.3")}


def _xy(pid):
    c, r = POS.get(pid) or CUT_POS[pid]
    return c * KX, r * KY


def _reduced_edges(plan):
    """Связи без транзитивных (они следуют из остальных)."""
    def anc(x, seen):
        for q in plan.preds[x]:
            if q not in seen:
                seen.add(q)
                anc(q, seen)
        return seen
    edges = []
    for p in plan.disc:
        for q in plan.preds[p]:
            if not any(q in anc(r, set()) for r in plan.preds[p] if r != q):
                edges.append((q, p))
    return edges


def _node(ax, pid, plan, kind):
    x, y = _xy(pid)
    face, edge, lw, ls = {"crit": ("white", RED, 2.2, "-"), "norm": ("white", INK, 1.0, "-"),
                          "done": ("#f2f2f2", INK, 1.0, "-"), "cut": ("white", MUTED, 1.0, (0, (4, 3)))}[kind]
    ax.add_patch(Rectangle((x - BW / 2, y - BH / 2), BW, BH, fc=face, ec=edge, lw=lw, ls=ls, zorder=3))
    name = M.PK[pid]["short"]
    if kind == "done":
        ax.text(x, y - 0.17, "%s  %s" % (pid, name), ha="center", va="center", fontsize=10, fontweight="bold", zorder=4)
        ax.text(x, y + 0.22, "выполнен 03.10", ha="center", va="center", fontsize=9, zorder=4)
        return
    if kind == "cut":
        ax.text(x, y - 0.17, "%s  %s" % (pid, name), ha="center", va="center", fontsize=10, color=MUTED, zorder=4)
        ax.text(x, y + 0.22, "%s ч" % ru(M.E(pid), 0), ha="center", va="center", fontsize=9, color=MUTED, zorder=4)
        return
    ax.text(x, y - 0.30, "%s  %s" % (pid, name), ha="center", va="center", fontsize=10, fontweight="bold", zorder=4)
    ax.plot([x - BW / 2, x + BW / 2], [y - 0.09, y - 0.09], color=edge, lw=0.6, zorder=4)
    cols = (x - BW / 3 + 0.05, x, x + BW / 3 - 0.05)
    top = (ru(plan.ES[pid]), ru(plan.dur(pid)), ru(plan.EF[pid]))
    bot = (ru(plan.LS[pid]), ru(abs(plan.TF[pid])), ru(plan.LF[pid]))
    for cx, a, b in zip(cols, top, bot):
        ax.text(cx, y + 0.10, a, ha="center", va="center", fontsize=9.5, zorder=4)
        ax.text(cx, y + 0.36, b, ha="center", va="center", fontsize=9.5, zorder=4)


def _arrow(ax, a, b, color, lw, z=2):
    ax.annotate("", xy=b, xytext=a, zorder=z,
                arrowprops=dict(arrowstyle="-|>,head_width=0.25,head_length=0.5", color=color, lw=lw,
                                shrinkA=0, shrinkB=0, mutation_scale=11))


def draw_network(plan, path):
    setup()
    fig, ax = plt.subplots(figsize=(21, 12.2))
    crit = plan.crit_path
    crit_edges = set(zip(crit, crit[1:]))
    for q, p in _reduced_edges(plan):
        (x1, y1), (x2, y2) = _xy(q), _xy(p)
        is_c = (q, p) in crit_edges
        color, lw = (RED, 2.2) if is_c else (INK, 0.8)
        if (q, p) in ELBOW:
            ax.plot([x1 + BW / 2, x2], [y1, y1], color=color, lw=lw, zorder=2)
            _arrow(ax, (x2, y1), (x2, y2 - BH / 2), color, lw)
        else:
            _arrow(ax, (x1 + BW / 2, y1), (x2 - BW / 2, y2), color, lw, z=3 if is_c else 2)
    x0, y0 = _xy("1.1")
    for p in plan.disc:
        if not plan.preds[p] and p in POS:
            x2, y2 = _xy(p)
            first = p == crit[0]
            _arrow(ax, (x0 + BW / 2, y0), (x2 - BW / 2, y2), RED if first else INK, 2.2 if first else 0.8)
    _node(ax, "1.1", plan, "done")
    for p in plan.disc:
        _node(ax, p, plan, "crit" if p in plan.critical else "norm")
    bars = [("1.3", POS["2.4"][0], POS["1.4"][0], -1.75), ("2.1", POS["2.4"][0], POS["1.4"][0], -1.2),
            ("6.2", POS["3.1"][0], POS["6.3"][0], -0.65)]
    for pid, c0, c1, row in bars:
        xa, xb, y = c0 * KX - BW / 2, c1 * KX - BW / 2, row * KY
        ax.add_patch(Rectangle((xa, y - 0.28), xb - xa, 0.56, fc="#ededed", ec=INK, lw=0.8, zorder=3))
        w = plan.win_net[pid]
        ax.text((xa + xb) / 2, y, "%s  %s (гамак), %s ч, %s дн" % (pid, M.PK[pid]["short"], ru(M.E_rem(pid), 0), ru(w[1] - w[0])),
                ha="center", va="center", fontsize=10, zorder=5)
    cx0 = CUT_POS["4.3"][0] * KX - BW / 2
    cy = CUT_POS["4.3"][1] * KY
    ax.text(cx0, cy - 0.95, "Исключены из базового плана:", fontsize=10, va="center")
    for p in CUT_POS:
        if p in plan.cut:
            _node(ax, p, plan, "cut")
    lx, ly = -0.35 * KX, 6.95 * KY
    ax.add_patch(Rectangle((lx, ly), BW, BH, fc="white", ec=INK, lw=1.0, zorder=3))
    ax.text(lx + BW / 2, ly + BH / 2 - 0.30, "№  Пакет", ha="center", va="center", fontsize=10, fontweight="bold")
    ax.plot([lx, lx + BW], [ly + BH / 2 - 0.09] * 2, color=INK, lw=0.6, zorder=4)
    for cx, a, b in zip((lx + BW / 2 - BW / 3 + 0.05, lx + BW / 2, lx + BW / 2 + BW / 3 - 0.05), ("ES", "D", "EF"), ("LS", "R", "LF")):
        ax.text(cx, ly + BH / 2 + 0.10, a, ha="center", va="center", fontsize=9.5)
        ax.text(cx, ly + BH / 2 + 0.36, b, ha="center", va="center", fontsize=9.5)
    ax.text(lx + BW + 0.3, ly + 0.3, "R — полный резерв, раб. дни от 19.10.2026", fontsize=10, va="center")
    ax.text(lx + BW + 0.3, ly + 0.72, "красным — критический путь", fontsize=10, va="center")
    ax.set_xlim(-0.75 * KX, 9.3 * KX)
    ax.set_ylim(8.4 * KY, -2.2 * KY)
    ax.axis("off")
    fig.suptitle("Сетевой график (вариант Б)", fontsize=16, fontweight="bold", x=0.035, y=0.975, ha="left")
    fig.text(0.035, 0.94, "Критический путь: %s.  Tкр = %s раб. дн,  Tдир = %d раб. дн." % (" → ".join(crit), ru(plan.T_net), M.T_ACC),
             fontsize=11.5, ha="left")
    fig.subplots_adjust(left=0.01, right=0.99, top=0.925, bottom=0.01)
    fig.savefig(path)
    plt.close(fig)


# ---------------------------------------------------------------------------
# Диаграмма Ганта
# ---------------------------------------------------------------------------
def draw_gantt(plan, path):
    setup()
    rows, y, last = [], 0.0, None
    for pid in M.PK:
        if pid[0] != last:
            y += 0.5 if last else 0.0
            rows.append(("H", pid[0], y))
            y += 0.85
            last = pid[0]
        rows.append(("P", pid, y))
        y += 1.0
    fig, ax = plt.subplots(figsize=(18, 11))
    num = mdates.date2num
    x_min, x_max = num(datetime(2026, 10, 16)), num(datetime(2027, 1, 2))
    chain = set(plan.res_chain)
    d = datetime(2026, 10, 19)
    while num(d) < x_max:
        ax.axvline(num(d), color=GRID, lw=0.7, zorder=0)
        d += timedelta(days=7)
    y_top, y_bot = -1.9, y - 0.4
    for kind, key, yy in rows:
        if kind == "H":
            ax.text(x_min - 0.4, yy, BRANCH[key], ha="right", va="center", fontsize=10.5, fontweight="bold")
            continue
        pid, p = key, M.PK[key]
        off = pid in plan.cut
        muted = off or p["kind"] == "done"
        ax.text(x_min - 0.4, yy, "%s  %s" % (pid, p["name"]), ha="right", va="center", fontsize=10, color=MUTED if muted else INK)
        if muted:
            ax.text(num(datetime(2026, 10, 19)), yy, "исключён" if off else "выполнен 03.10", va="center", fontsize=9, color=MUTED)
            continue
        if p["kind"] == "loe":
            a, b = plan.win[pid]
            xa, xb = num(M.x_start(a)), num(M.x_end(b))
            ax.barh(yy, xb - xa, left=xa, height=0.42, color=LOE, edgecolor=INK, lw=0.6, zorder=2)
            ax.text(xa + 0.6, yy, ", ".join(surname(x) for x in plan.H[pid]), ha="left", va="center", fontsize=9, zorder=6)
            continue
        s, f = plan.S[pid], plan.F[pid]
        xa, xb = num(M.x_start(s)), num(M.x_end(f))
        ax.barh(yy, xb - xa, left=xa, height=0.52, color=RED if pid in chain else BAR, zorder=3)
        label = ", ".join(surname(x) for x in plan.team[pid]) if len(plan.team[pid]) < 7 else "вся команда"
        x_lab, ha = xb + 0.5, "left"
        if pid in ("6.3", "1.4"):
            x_lab, ha = xa - 0.5, "right"
        if pid == "6.3":
            xe = num(M.x_end(float(M.T_ACC)))
            ax.barh(yy, xe - xb, left=xb, height=0.52, color=BUF, edgecolor=INK, lw=0.6, zorder=2)
            ax.text((xb + xe) / 2, yy, "запас", ha="center", va="center", fontsize=9, zorder=6)
        ax.text(x_lab, yy, label, ha=ha, va="center", fontsize=9, zorder=6, bbox=dict(fc="white", ec="none", pad=1.0))
    xs = num(datetime(2026, 10, 17, 12))
    ax.axvline(xs, color=INK, lw=0.9, ls=(0, (4, 3)), zorder=1)
    ax.text(xs, y_top + 0.15, "статус-дата\n17.10", ha="center", va="bottom", fontsize=9.5)
    for code, dt, t, _ in M.MILESTONES:
        if t == 0:
            continue
        xm = num(datetime(dt.year, dt.month, dt.day, 12))
        ax.axvline(xm, color=INK, lw=0.9, zorder=1)
        ax.plot([xm], [y_top + 1.15], marker="D", ms=8, color=INK, zorder=5, clip_on=False)
        ax.text(xm, y_top + 0.15, "%s\n%s" % (code, dt.strftime("%d.%m")), ha="center", va="bottom", fontsize=10, fontweight="bold")
    ax.set_xlim(x_min, x_max)
    ax.set_ylim(y_bot, y_top)
    ax.set_yticks([])
    ticks, d = [], datetime(2026, 10, 19)
    while num(d) < x_max:
        ticks.append(num(d))
        d += timedelta(days=7)
    ax.set_xticks(ticks)
    ax.set_xticklabels([mdates.num2date(t).strftime("%d.%m") for t in ticks], fontsize=9.5)
    ax.tick_params(axis="x", length=3)
    for s_ in ("top", "right", "left"):
        ax.spines[s_].set_visible(False)
    handles = [Patch(fc=RED, label="критическая цепочка"), Patch(fc=BAR, label="остальные работы"),
               Patch(fc=LOE, ec=INK, label="гамак"), Patch(fc=BUF, ec=INK, label="запас до 25.12"),
               Line2D([0], [0], marker="D", color="none", mfc=INK, mec=INK, ms=8, label="пара")]
    ax.legend(handles=handles, loc="upper center", bbox_to_anchor=(0.5, -0.04), ncol=5, frameon=False, fontsize=10)
    fig.suptitle("Диаграмма Ганта (вариант Б, после выравнивания ресурсов)", fontsize=16, fontweight="bold", x=0.02, y=0.975, ha="left")
    fig.subplots_adjust(left=0.265, right=0.985, top=0.935, bottom=0.09)
    fig.savefig(path)
    plt.close(fig)


# ---------------------------------------------------------------------------
# Загрузка ресурсов: до и после выравнивания
# ---------------------------------------------------------------------------
def draw_load(plan, path):
    setup()
    wk, after, cap = plan.load(True)
    wk0, before, cap0 = plan.load(False)
    n = len(wk)
    fig, axes = plt.subplots(2, 4, figsize=(18, 8), sharey=True)
    axes = axes.ravel()
    labels = [w[0].strftime("%d.%m") for w in wk]
    top = 0
    for ax, x in zip(axes, I.ALL):
        a = [100 * after[x][k] / cap[x][k] for k in range(n)]
        b = [100 * (before[x][k] / cap0[x][k]) if k < len(before[x]) else 0 for k in range(n)]
        top = max(top, max(b), max(a))
        ax.bar(range(n), a, width=0.62, color="#a6a6a6", zorder=3, label="после выравнивания")
        ax.step([-0.5] + [k + 0.5 for k in range(n)], [b[0]] + b, where="pre", color=INK, lw=1.4, zorder=4, label="до выравнивания")
        over = [k for k in range(n) if b[k] > 100.5]
        ax.plot(over, [b[k] for k in over], ls="none", marker="o", ms=6, color=RED, zorder=5, label="перегруз")
        ax.axhline(100, color=INK, lw=0.8, ls=(0, (4, 3)), zorder=2)
        ax.set_title("%s, %d ч/нед" % (I.PEOPLE[x]["name"], plan.hours[x]), fontsize=11, loc="left", pad=6)
        ax.set_xticks(range(n))
        ax.set_xticklabels(labels, fontsize=8.5, rotation=45)
        ax.grid(axis="y", color=GRID, lw=0.7, zorder=0)
        ax.set_axisbelow(True)
        for s_ in ("top", "right"):
            ax.spines[s_].set_visible(False)
    for ax in axes:
        ax.set_ylim(0, max(225, top * 1.08))
        ax.set_yticks([0, 50, 100, 150, 200])
        ax.set_yticklabels(["0", "50%", "100%", "150%", "200%"], fontsize=9.5)
    ax = axes[7]
    ax.axis("off")
    h, l = axes[0].get_legend_handles_labels()
    ax.legend(h, l, loc="center left", frameon=False, fontsize=11)
    fig.suptitle("Загрузка по неделям, % от недельного фонда", fontsize=16, fontweight="bold", x=0.02, y=0.975, ha="left")
    fig.subplots_adjust(left=0.045, right=0.99, top=0.89, bottom=0.085, hspace=0.45, wspace=0.08)
    fig.savefig(path)
    plt.close(fig)
