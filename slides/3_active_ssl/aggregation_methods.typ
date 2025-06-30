#import "/globals.typ": *

#table(
  // SETTINGS
  columns: 6,
  stroke: none,
  align: left + horizon,
  inset: .5em,

  // HEADER
  toprule,

  table.header(
    table.cell(rowspan: 2)[Aggregation method],
    header-pred-spectrum,
    [#h(2em)],
    header-gt-spectrum,
    header-prec,
    header-recall,
    [],
    header-prec,
    header-recall,
  ),

  midrule,

  // ROWS
  // Blending             delta_min   Prec                  Recall                  ||    Prec      Recall
  [Average], [72.33], [46.60], [], [96.02], [77.70],
  [#psi-dnn], [*86.05*], [*53.28*], [], [*99.74*], [*90.54*],

  [], bottomrule,
)
