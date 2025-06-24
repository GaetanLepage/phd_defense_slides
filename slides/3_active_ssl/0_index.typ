#import "/globals.typ": *

= Active Sound Source Localization

#slide(title: "Motivation")[
  - Leverage the robot movement to enhance localization
]

#slide(title: "Problem statement")[

]

#slide(title: "Approach")[
  - Project static SSL DoA spectrum to egocentric maps
  - Aggregate these maps into a single final heatmap
]


#slide(title: "Pipeline", align: center)[
  #image("figures/pipeline_2lines.svg")
]

#slide(title: "Static SSL model")[
  - Encode DoA as a continuous function over $[-pi, pi]$
][
  #image("figures/doa_encoding.svg")
]

#slide(title: "Static localizer", align: center)[
  #todo[Make it horizontal]
][
  #image("figures/multisource_nn_architecture.svg")
]

#slide(title: "Aggregation strategy", align: center)[
  - Aggregate shifted maps into a single heatmap

  Two options:
  - Averaging
  - U-Net
  #todo[Add schema to describe the process]
][
  #image("figures/nn_architecture.svg")
]

#slide(title: "Clustering")[
  - Extract descrete 2D position predictions from the heatmap
]

#slide(title: "Evaluation metrics")[ ][
  $
    m(
      hat(X)^i_k,
      X^i_j
    ) = cases(
      1
      #h(2em)
      // estimation is "close enough"
      && "if" d (k) < delta\
      && #h(1em)"and" k = limits("argmin")_(k' in {1, dots, hat(z_i)}) d(k'), // it is the closest of all
      0
      && "otherwise,"
    )
  $
  #pause
  $
    "Precision" = (
    sum_i
    sum_(j=1)^(z_i)
    sum_(k=1)^(hat(z)_i)
    m(
      hat(X)_(i, k),
      X_(i, k)
    )
    ) / (sum_i hat(z)_i),
  $
  $
    "Recall" = (
    sum_i
    sum_(j=1)^(z_i)
    sum_(k=1)^(hat(z)_i)
    m(
      hat(X)_(i, k),
      X_(i, k)
    )
    ) / (sum_i z_i).
  $
]

#slide(title: "Experimental setup")[
  #image("figures/dataset_setup.svg")
]

#slide(title: "Comparison of aggregation methods")[

  #todo[Insert table]
]

#slide(title: "Summary")[
  #todo[Summary of the section]
]
