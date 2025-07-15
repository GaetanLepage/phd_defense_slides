#import "/globals.typ": *

#slide(title: "", align: center + horizon)[
  #image("figures/outline.svg", height: 90%)
]

= Active Sound Source Localization

#slide(title: "The Static SSL Problem", repeat: 2)[
  #set text(size: .9em)
  - SSL (Sound Source Localization): estimate the position of one or multiple sound sources
    - Dense scientific literature: from classical sound processing methods~@gustafsson2004source@schmidt1986multiple to deep learning techniques~@grumiaux2022survey
    - Often applied to robotics~@argentieri2015survey
    - Multiple variations of the task
  #let height = 20%
  #only(1)[
    #image("figures/ssl_task_mapping_single_source.svg", height: height)
  ]
  #only(2)[
    #image("figures/ssl_task_mapping_multi_source.svg", height: height)
  ]
][
  #let height = 65%
  #only(1)[
    #image("figures/ssl_task_single_source.svg", height: height)
  ]
  #only(2)[
    #image("figures/ssl_task_multi_source.svg", height: height)
  ]
]

#slide(title: "Active SSL", align: top)[
  // #heading(depth: 2, outlined: false, numbering: none)[Active SSL]
  //
  #set text(size: .9em)

  *Motivation:*
  - Real-world robotics scenarios are often dynamic
  - Static SSL frameworks struggle predicting the source-array distance

  #pause

  *Intuition:*
  - Aggregate instantaneous angular estimates over time
  - Leverage the robot movement to refine the predictions of the sources' 2D position
  #pause

  *Literature:*
  - Several works in the Robotics literature~@nakadai2000active @nguyen2017long @bustamante2016towards
  - Lack of deep-learning-based methods\
    Multiple works involving moving sources (e.g. LOCATA challenge~@evers2020locata), but only few considering mobile microphones
]

// #slide(title: "Problem statement")[
//
// ]

#slide(repeat: 2, title: "Proposed Approach", composer: (3fr, 2fr))[
  - Discrete step process
  - Project static SSL predictions to a 2D egocentric view
  - Aggregate these maps into a single final heatmap

  #only(1)[
    #image("figures/map_single_step.svg", height: 60%)
  ]
  #only(2)[
    #image("figures/combination_dnn.svg", height: 60%)
  ]
][
  #set align(center)
  #image("figures/robot_moving.svg", width: 100%)
]


#slide(title: "Static SSL Model (1/2): DoA Spectrum Regression")[
  // #set text(size: .9em)
  - Encode DoA values over $[-pi, pi]$ (discretized)~@he_neural_2021
  - Can represent an arbitrary number of sources
  - Ground-truth DoA values are represented with Gaussians
  // TODO: add an example with prediction too!

  #{
    set align(center)
    // image("figures/doa_encoding.svg", width: 50%)
    // TODO: show in two steps
    include "figures/doa_encoding.typ"
  }

  #let gt = text(rgb(0, 0, 200))[$o$]
  #let pred = text(red)[$hat(o)$]
  - Thanks to this representation, the SSL task becomes a DoA spectrum regression:
    $
      cal(L) = norm(#pred - #gt)_2^2
    $ // TODO: color hat(o) in red and o in blue (to match the figure)
]


#anim_slide(
  5,
  title: "Static SSL Model (2/2): Network Architecture",
  image-prefix: "/slides/3_active_ssl/figures/multisource_nn_architecture_",
  image-width: 100%,
)

// #slide(title: "Pipeline", align: center, repeat: )[
//   #image("figures/pipeline_2lines.svg")
// ]
#anim_slide(
  9,
  title: "Active Sound Source Localization Pipeline",
  // TODO: add one more step before shifting
  image-prefix: "/slides/3_active_ssl/figures/pipeline_",
)

// TODO refaire l'anim à la fin
#slide(title: "Aggregation strategy", repeat: 3, align: top)[
  #v(1em)

  *Aggregate shifted maps into a single heatmap*

  #only("2-")[
    Two methods were explored:
    - Naive averaging:
    $
      bold(hat(M))_t = 1 / H sum_(t'=0)^(H-1) M_(t - t')
    $
  ]
  #only("3-")[
    - U-Net model @ronneberger2015u:
    $
      bold(hat(M))_t = Psi_"DNN" (M_(t - H + 1), dots, M_t)
    $
  ]
][
  #v(3em)
  #set align(center)
  #let width = 80%
  #stack(
    dir: ltr,
    spacing: -2em,

    only("2-")[
      #figure(
        image("figures/combination_avg.svg", width: width),
        caption: "Averaging",
      )
    ],
    only("2")[
      #rect(width: width, height: 1em, fill: none, stroke: none)
    ],
    only("3")[
      #figure(
        image("figures/combination_dnn.svg", width: width),
        caption: "DNN",
      )
    ],
  )
  // #only("2-")[
  //   #image("figures/combination_avg.svg")
  // ]
  // #only("3")[
  //   #image("figures/combination_dnn.svg")
  // ]
]

#slide(title: "Neural Network-Based Aggregation")[
  // #place(dx: -1em, image("figures/nn_architecture.svg", width: 110%))
  #image("figures/nn_architecture.svg")
  #v(2em)
  $
    cal(L) = 1/p^2 norm(cal(M)_t - cal(M)_t^*)_F^2
  $
]


#slide(title: "Clustering")[
  *Extract discrete 2D position predictions from the heatmap*

  + Low values are filtered out from the egocentric heatmap (threshold $tau$)
  + The DBSCAN algorithm @schubert_dbscan_2017 is used to cluster pixels into several groups
  + The position of the highest-value pixel of each cluster is used as the final detection
][
  // TODO: add an image of the map after thresholding
  // TODO: remove axis
  #image("figures/clustering.svg")
]

#slide(title: "Experimental Setup")[
  #image("figures/dataset_setup.svg")
  #set text(size: .8em)
  #place(horizon + left, dx: 61%)[
    - Dataset collection:
      - 1-4 sources placed randomly
      - The robot starts close to a wall
      - The orientation is drawn randomly at each\ step: $theta_(t+1) tilde cal(N)(theta_t, sigma_theta^2)$
      - The agent moves forward in the new direction\ by 50cm
      - The trajectory runs for $H$ steps
  ]
]


#let m = text(olive)[$m$]
#let prec = text(maroon)[Precision]
#let recall = text(eastern)[Recall]
// #let delta = text(orange)[$delta$]
#slide(title: "Standard Evaluation Metrics", repeat: 3, align: top, composer: (4fr, 5fr))[

  #only(1)[
    #set align(bottom)
    #image("figures/metrics_1.svg")
  ]
  #only("2-")[
    #set align(bottom)
    #image("figures/metrics_2.svg")
  ]
  // #set text(size: .9em)

  // #only("2-")[
  //   + #m counts the number of positive prediction-GT matches
  // ]
  // #only("3-")[
  //   + The #prec measures the proportion of correct matches among the predictions
  // ]
  // #only("4-")[
  //   + The #recall counts the proportion of GT positions that have correcty been identified
  // ]
][
  // #v(2em)
  - Define a threshold $delta$ for defining correct detections
  - Match predictions and ground truths

  #let sample_index = $i$
  #let pos(char, index) = $char_(#sample_index, index)$
  #let gt(index) = $#pos($X$, index)$
  #let pred(index) = $#pos($hat(X)$, index)$
  #let dist(index) = $norm(#pred(index) - #gt(index))_2$
  #let preds = text(rgb("#9673A6"))[\#predictions]
  #let gt = text(rgb("#004C99"))[\#sources]
  #let correct = text(rgb("#009900"))[\#correct]

  #only("2-")[
    $
      // #prec = "#correct" / "#predictions"
      "Precision" = #correct / #preds
    $
    $
      // #prec = "#correct" / "#predictions"
      "Recall" = #correct / #gt
    $
  ]

  #only("3-")[
    In this example:
    - $"Precision" = 1 / 3 approx 33%$
    - $"Recall" = 1 / 2 = 50%$
  ]
]

#slide(title: "Comparison of Aggregation Methods", align: center, config: (show-strong-with-alert: false))[

  #let height = 45%
  #stack(
    dir: ltr,
    figure(image("figures/combination_gt.svg", height: height), caption: "Ground truth"),
    figure(
      image(
        "figures/combination_avg.svg",
        height: height,
      ),
      caption: "Average",
    ),
    figure(
      image(
        "figures/combination_dnn.svg",
        height: height,
      ),
      caption: "DNN",
    ),
  )
  #pause
  #include "aggregation_methods.typ"
]

#slide(title: "Summary - Active SSL")[
  #set text(size: 1.2em)

  - *Complete pipeline* for active multi-source localization
  - *Aggregation of information accross time* to build fine 2D position estimates
  - Leveraging of a *static SSL deep-learning model*
  - *Deep U-Net style architecture* for combining heatmaps
  - Training of the *static SSL model* and the *U-Net blender* using synthetic datasets generated from our simulator
]
