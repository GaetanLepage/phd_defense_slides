#import "/globals.typ": *
#show math.equation: set align(left)
#let units = "(s, (%))"
#table(
  // SETTINGS
  columns: 5,
  stroke: none,
  align: left + horizon,
  // row-gutter: .5em,
  inset: 0% + 10pt,

  // HEADER
  toprule,

  table.header([], [$T_"sim" #units$], [$t_"RIR" #units$], [$t_"conv" #units$], [$t_"STFT" #units$]),

  midrule,

  // rdc "python rl_audio_nav/supervised_localization/bin/evaluate.py 60X 0"

  // ROWS
  [gpuRIR], [*21.7* (100%)], [*3.69* (17%)], [14.6 (67%)], [2.4 (11%)],
  [Pyroomacoustics], [124 (100%)], [109 (88%)], [11.6 (9.4%)], [2.3 (1.8%)],

  bottomrule,
)
