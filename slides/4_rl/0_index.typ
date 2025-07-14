#import "/globals.typ": *

#slide(title: "Plan", align: center + horizon)[
  #image("figures/outline.svg", height: 90%)
]

= Deep Reinforcement Learning for Sound-Driven Navigation

#slide(title: "Motivation & problem statement")[
  *Goal:* Perceptually motivated navigation~@majumder2021move2hear

  - Robots are expected to _understand_ human speech
  - _Automatic Speech Recognition (ASR)_ is the first step of the speech understanding pipeline
  - How can navigation help with improving the robot's ASR performance?
]

#slide(title: "Measuring ASR performance")[
  The _Word Error Rate (WER)_ measures the ASR performance.

  $->$ _WER:_ Minimum edit distance between two sentences:

  #pause

  #let s = text(orange)[\#substitutions]
  #let d = text(red)[\#deletions]
  #let i = text(green)[\#insertions]
  #let n = text(blue)[\#words]
  $
    "WER" = (#s + #d + #i) / #n
  $
  // - #s: number of substitutions
  // - #d: number of deletions
  // - #i: number of insertions
  // - $n$: number of words in the reference

  #pause
  *Example:*
  - Reference: #h(2em) _Obviously, he was #text(green)[\_\_]#h(.3em) able to catch the #text(orange)[last~] bus on time #text(red)[today]._
  - Prediction: #h(2em - 0.2em) _Obviously, he was #text(green)[not] able to catch the #text(orange)[past] bus on time #text(red)[\_\_\_\_]#h(.3em)._
  #pause
  $
    "WER" = (1 + 1 + 1) / 12 = 0.25
  $
]

#slide(title: "Reverberation impact on WER")[
  #include "figures/wer_maps_reverb/fig.typ"

  #v(2em)

  - WER increases as reverberation grows
  - Robot positioning impacts ASR performance
  - Correct positioning matters more as $T_60$ increases
]

#let C_t = text(maroon)[$C_t$]
#slide(title: "Problem Statement")[
  *Idea:* Frame the navigation problem as a sequential decision problem

  - At each step, the robot records a short audio snippet;
  - Based on this observation, it decides what its next move should be;
  - The environment rewards the robot based on a WER estimate for its current position;

  $->$ Reinforcement learning is very well suited to this problem.
]

#slide(repeat: 3, title: "Reinforcement Learning", align: left + top, composer: (10fr, 9fr))[
  #set text(size: .9em)
  RL solves sequential decision problems, formalized as *Markov Decision Processes (MDPs)*.

  #todo[cite @sutton1998reinforcement]

  #only("2-")[
    At each step:
    - The #text(rgb("#9673A6"))[agent] senses the #text(rgb("#D79B00"))[environment] by observing the #text(rgb("#00994D"))[state $s_t$] $in cal(S)$
    - It chooses an #text(rgb("#004C99"))[action $a_t$] in the action set $cal(A)$
    - It receives a #text(rgb("#B85450"))[reward $r_t$]
  ]

  #only(3)[
    #line(length: 100%)
    Our environment:
    - The #text(rgb("#B85450"))[reward] is a decreasing function of the WER:

    #place(auto, float: true, scope: "column", dx: 6em, dy: 0em)[
      #set text(size: .9em)
      $
        r_t = cases(
          -mu_W & quad "if the agent tries to hit a wall",
          mu_C exp(- xi_C #C_t)
          - mu_m bb(1) (a_t = "`FORWARD`") & quad "otherwise"
        )
      $
    ]
  ]
][
  // #let height = 70%
  #set align(center)
  #only(2)[
    #image("figures/rl_schema_1.svg", width: 100%)
  ]
  #only(3)[
    #image("figures/rl_schema_2.svg", width: 100%)
  ]
]


#slide(title: "WER Cost Maps", composer: (3fr, 2fr))[

  - The cost of a state requires an estimate of the average WER for this position;
  - The WER cost maps can be either *directional* or *omnidirectional*;

  *Problem:* WER can't be computed at the environment run-time.

  $->$ Pre-compute statistical estimates of the theoretical WER cost of a state.

  #set text(size: .7em)
  #let xa = $bold(x)_a$
  #let aa = $alpha_a$
  #let xs = $bold(x)_s$
  $
    C_"WER" (#xa, #aa) = EE_((v, t) in cal(D))
    lr(
      [
        1/100
        "WER"lr(
          (
            underbrace(
              "ASR"_psi
              lr(
                [
                  "listened"(
                    v,
                    #xa,
                    #aa,
                    #xs
                  )
                ],
                size: #120%,
              ),
              "predicted transcript" hat(t)
            ),
            thick t
          ),
          size: #120%,
        )
      ],
      size: #100%,
    )
  $
][
  #image("figures/directional_map.svg")
]

#slide(title: "Agent Architecture", align: center + horizon)[
  #image("figures/rl_architecture_v3_horizontal.svg", width: 100%)
  #set align(left)
  *Two-stage training:*
  + Train the backbone on a supervised single-source localization task
  + Train the #text(fill: rgb("#9673A6"))[value] and #text(fill: rgb("#B85450"))[policy] heads with PPO~@schulman2017proximal
]

#slide(repeat: 5, title: "SSL Backbone Architecture", align: top)[
  #let image_height = 75%
  #{
    set align(center)
    only(1)[#image("figures/ssl_backbone_1.svg", height: image_height)]
    only(2)[#image("figures/ssl_backbone_2.svg", height: image_height)]
    only("3-4")[#image("figures/ssl_backbone_3.svg", height: image_height)]
    only(5)[#image("figures/ssl_backbone_4.svg", height: image_height)]
  }
  #only("4-")[
    *Training loss:*

    #let t = text(olive)[$theta$]
    #let t_hat = text(maroon)[$hat(theta)$]
    $cal(L)_"DoA"(
      #t_hat, #t
    ) =
    1 - (
      sin(#t) sin(#t_hat)
      + cos(#t) cos(#t_hat)
    )$
  ]
]

#slide(title: "Agent Trajectories", align: center)[
  #image("figures/traj.svg")
  // #image("figures/traj.gif")
]

#slide(title: "Comparison with Baselines", config: (show-strong-with-alert: false))[

  #heading(depth: 2, outlined: false, numbering: none)[Metrics]

  #stack(
    dir: ltr,
    spacing: 20%,
    [
      Undiscounted cumulated reward:
      $
        #mean-cum-reward = 1 / #n-ep sum_(i=1)^#n-ep sum_(t=1)^T r_(i, t)
      $
      #pause
    ],
    [
      Mean final cost:
      $
        #mfc = 100 / #n-ep sum_(i=1)^#n-ep C(s_(i, T))
      $
    ],
  )

  // #pause
  // #set text(size: .8em)

  #pause
  #heading(depth: 2, outlined: false, numbering: none)[Results]
  #include "table_baselines.typ"
]

#slide(title: "Summary - Deep RL for Navigation")[
  #set text(size: 1.2em)
  - Definition of a novel *perceptually-motivated navigation task*
  - Improving the *ASR performance* by position optimization
  - Implementation of a complete Gym-compatible @brockman2016openai environment from our simulator
  // TODO capitalization of "Deep"
  - Training of a *Deep RL agent* that successfully solves the task
]
