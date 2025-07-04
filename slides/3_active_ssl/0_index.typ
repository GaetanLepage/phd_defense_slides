#import "/globals.typ": *

#slide(title: "", align: center + horizon)[
  #image("figures/outline.svg", height: 90%)
]

= Active Sound Source Localization

#slide(title: "From Static to Active SSL", repeat: 2, align: top)[
  // #set align(top)
  #set text(size: .9em)
  - SSL (Sound Source Localization): estimate the position of one or multiple sound sources
    - Dense scientific literature: from classical sound processing methods~@gustafsson2004source~@schmidt1986multiple to deep learning techniques~@grumiaux2022survey
    - Often applied to robotics @argentieri2015survey
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

#slide(title: "From Static to Active SSL", align: top)[
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
  - Several works in the Robotics literature~@nakadai2000active @nguyen2018autonomous @bustamante2016towards
  - Lack of deep-learning-based methods\
    Multiple works involving moving sources (e.g. LOCATA challenge~@evers2020locata), but only few considering mobile microphones
]

// #slide(title: "Problem statement")[
//
// ]

#slide(repeat: 2, title: "Approach", composer: (3fr, 2fr))[
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
  - Encode DoA as a continuous function over $[-pi, pi]$~@he_neural_2021
  - Discretized over 360 values
  - Can represent an arbitrary number of sources
  - Ground-truth DoA of each source is represented with a discretized Gaussian window centered on it
  - The SSL task becomes a DoA spectrum regression (with a DNN for e.g.):
    $
      cal(L) = norm(hat(o) - o)_2^2
    $
  #set align(center)
  // TODO: add an example with prediction too!
  #image("figures/doa_encoding.svg", width: 50%)
]


#anim_slide(
  5,
  title: "Static SSL Model (2/2): Network Architecture",
  image-prefix: "/slides/3_active_ssl/figures/multisource_nn_architecture_",
  image-height: 80%,
)

// #slide(title: "Pipeline", align: center, repeat: )[
//   #image("figures/pipeline_2lines.svg")
// ]
#anim_slide(
  6,
  title: "Active sound source localization pipeline",
  // TODO: make final
  image-prefix: "/slides/3_active_ssl/figures/pipeline_",
)

#slide(title: "Aggregation strategy", repeat: 3, align: top)[
  #v(1em)

  $->$ *Aggregate shifted maps into a single heatmap*

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
        numbering: none,
      )
    ],
    only("2")[
      #rect(width: width, height: 1em, fill: none, stroke: none)
    ],
    only("3")[
      #figure(
        image("figures/combination_dnn.svg", width: width),
        caption: "DNN",
        numbering: none,
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

#slide(title: "Neural network-based aggregation", composer: (2fr, 1fr))[
  #place(dx: -1em, image("figures/nn_architecture.svg", width: 110%))
][
  #image("figures/combination_gt.svg")
  $
    cal(L) = norm(cal(M)_t - cal(M)_t^*)_F
  $
]


#slide(title: "Clustering")[
  $->$ *Extract discrete 2D position predictions from the heatmap*

  + Low values are filtered out from the egocentric heatmap (threshold $tau$)
  + The DBSCAN algorithm @schubert_dbscan_2017 is used to cluster pixels into several groups
  + The position of the highest-value pixel of each cluster is used as the final detection
][
  #image("figures/clustering.svg")
]

#slide(title: "Experimental Setup")[
  #image("figures/dataset_setup.svg")
  #set text(size: .8em)
  #place(horizon + left, dx: 61%)[
    - Dataset collection:
      - The robot starts close to a wall
      - The orientation is drawn randomly at each\ step: $theta_(t+1) tilde cal(N)(theta_t, sigma_theta^2)$
      - The agent moves forward in the new direction\ by 50cm
      -
  ]
]


#let m = text(olive)[$m$]
#let prec = text(maroon)[Precision]
#let recall = text(eastern)[Recall]
#let delta = text(orange)[$delta$]
#slide(title: "Evaluation Metrics", repeat: 4, align: top)[

  #only(1)[
    #set align(bottom)
    #image("figures/metrics_1.svg", height: 40%)
  ]
  #only("2-")[
    #set align(bottom)
    #image("figures/metrics_2.svg", height: 40%)
  ]
  // #v(1em) //TODO use padding
  // TODO delta en couleur
  #set text(size: .9em)
  We define a threshold #delta for defining correct detections

  #only("2-")[
    + #m counts the number of positive prediction-GT matches
  ]
  #only("3-")[
    + The #prec measures the proportion of correct matches among the predictions
  ]
  #only("4-")[
    + The #recall counts the proportion of GT positions that have correcty been identified
  ]
][
  #v(2em)

  #let sample_index = $i$
  #let pos(char, index) = $char_(#sample_index, index)$
  #let gt(index) = $#pos($X$, index)$
  #let pred(index) = $#pos($hat(X)$, index)$
  #let dist(index) = $norm(#pred(index) - #gt(index))_2$
  #only("2-")[
    #set text(size: .8em)
    $
      #m (
        hat(X)^i_k,
        X^i_j
      ) = cases(
        1
        #h(2em)
        // estimation is "close enough"
          &&                                                  "if" #dist($k$) < #delta \
          && #h(1em)"and" k = limits("argmin")_(k' in {1, dots, hat(z_i)}) #dist($k'$), // it is the closest of all
        0 && "otherwise"
      )
    $
  ]
  #only("3-")[
    $
      #prec = (
      sum_i
      sum_(j=1)^(z_i)
      sum_(k=1)^(hat(z)_i)
      #m (
        hat(X)_(i, k),
        X_(i, k)
      )
      ) / (sum_i hat(z)_i)
    $
  ]
  #only("4-")[
    $
      #recall = (
      sum_i
      sum_(j=1)^(z_i)
      sum_(k=1)^(hat(z)_i)
      #m (
        hat(X)_(i, k),
        X_(i, k)
      )
      ) / (sum_i z_i)
    $
  ]
]

#slide(title: "Comparison of Aggregation Methods", align: center, config: (show-strong-with-alert: false))[

  #let height = 45%
  #stack(
    dir: ltr,
    figure(image("figures/combination_gt.svg", height: height), caption: "Ground truth", numbering: none),
    figure(
      image(
        "figures/combination_avg.svg",
        height: height,
      ),
      caption: "Average",
      numbering: none,
    ),
    figure(
      image(
        "figures/combination_dnn.svg",
        height: height,
      ),
      caption: "DNN",
      numbering: none,
    ),
  )
  #pause
  #include "aggregation_methods.typ"
]

#slide(title: "Summary")[
  #set text(size: 1.2em)

  - Complete pipeline for active multi-source localization
  - Training of the static SSL model and the U-Net blender using synthetic datasets generated from our simulator
  - Leveraging of a static SSL deep-learning model
  - Aggregation of information accross time to build fine 2D position estimates
  - Deep U-Net style architecture for combining heatmaps
]
