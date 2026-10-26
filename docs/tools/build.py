#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Сборка артефактов фазы 3, пункты 2–3: сетевой график (PERT) и расписание Stud Book.

Запуск:  python3 tools/build.py   (из папки baseline)
Исходные данные — tools/inputs.py. Результат — два xlsx, их PDF-копии и три png в папке baseline.
"""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import book_pert
import book_schedule
import figures
import inputs as I
import model as M
import pdf_export

OUT = Path(__file__).resolve().parent.parent


def main():
    pa = M.Plan(I.PLAN_A["key"], I.PLAN_A["title"], I.PLAN_A["extra"], I.PLAN_A["cut"])
    pb = M.Plan(I.PLAN_B["key"], I.PLAN_B["title"], I.PLAN_B["extra"], I.PLAN_B["cut"])
    results = [dict(label=label, name=name, plan=M.Plan(label or "-", name, extra, cut, override))
               for label, extra, name, cut, override in I.SCENARIOS]

    v = I.VERSION
    net_png = OUT / ("Сетевой график_%s.png" % v)
    gantt_png = OUT / ("Диаграмма Ганта_%s.png" % v)
    load_png = OUT / ("Загрузка ресурсов_%s.png" % v)
    figures.draw_network(pb, net_png)
    figures.draw_gantt(pb, gantt_png)
    figures.draw_load(pb, load_png)

    x1 = OUT / ("Сетевой график и PERT_%s.xlsx" % v)
    x2 = OUT / ("Расписание_%s.xlsx" % v)
    n1 = book_pert.build(x1, pa, pb, results, net_png)
    n2 = book_schedule.build(x2, pb, gantt_png, load_png)

    pdfs = []
    if pdf_export.available():
        pdfs.append(pdf_export.export(x1, x1.with_suffix(".pdf"), {book_pert.SH_FIG: net_png}))
        pdfs.append(pdf_export.export(x2, x2.with_suffix(".pdf"), {book_schedule.SH_FIG1: gantt_png, book_schedule.SH_FIG2: load_png}))
    else:
        print("PDF-копии не созданы: не найден Google Chrome")

    print("Вариант А: Tкр %.2f дн, P сети %.1f%%, окончание 6.3 по расписанию %s" % (
        pa.T_net, 100 * pa.p_net, M.finish_date(pa.S["6.3"], pa.F["6.3"])))
    print("Вариант Б: Tкр %.2f дн, P сети %.1f%%; расписание: 6.3 до %s, запас %.2f дн, P %.1f%%" % (
        pb.T_net, 100 * pb.p_net, M.finish_date(pb.S["6.3"], pb.F["6.3"]), pb.buffer, 100 * pb.p_sched))
    print("Критический путь Б:", " → ".join(pb.crit_path))
    print("Цепочка с учётом ресурсов:", " → ".join(pb.res_chain))
    print("Формулы: PERT %d (записано значений %d), расписание %d (%d) — все сверены с моделью" % (n1[0], n1[1], n2[0], n2[1]))
    for p in (pa, pb):
        for w in sorted(set(p.warnings)):
            print("ВНИМАНИЕ (%s): %s" % (p.key, w))
    for f in [x1, x2, net_png, gantt_png, load_png] + pdfs:
        print("записан:", f.name)


if __name__ == "__main__":
    main()
