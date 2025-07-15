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
#let state_color = rgb("#00994D")
#let action_color = rgb("#004C99")
#let reward_color = rgb("#B85450")
#let state_space = text(state_color)[$cal(S)$]
#let action_space = text(action_color)[$cal(A)$]
#slide(title: "Problem Statement")[
  *Idea:* Frame the navigation problem as a sequential decision problem

  - At each step, the robot records a short audio snippet;
  - Based on this observation, it decides what its next move should be;
  - The environment rewards the robot based on a WER estimate for its current position;

  $->$ Reinforcement learning is very well suited to this problem.
]

#slide(title: "Reinforcement Learning", align: left + top, composer: (10fr, 9fr))[
  #set text(size: .9em)
  RL @sutton1998reinforcement solves sequential decision problems, formalized as *Markov Decision Processes (MDPs)* @bellman1957markovian.

  At each step:
  - The #text(rgb("#9673A6"))[agent] senses the #text(rgb("#D79B00"))[environment] by observing the #text(state_color)[state $s_t$] in the state space #state_space
  - It chooses an #text(action_color)[action $a_t$] in the action set #action_space
  - It receives a #text(reward_color)[reward $r_t$]

  The goal is to maximize the cumulated discounted reward:
  $
    max_pi
    EE_pi [
      sum_(t=0)^infinity gamma^t r_(t + 1)
    ]
  $

  // #line(length: 100%)
][
  // #let height = 70%
  #set align(center)
  #image("figures/rl_schema_1.svg", width: 100%)
]

#let a-stay = `STAY`
#let a-forward = `FORWARD`
#let a-left = `TURN_LEFT`
#let a-right = `TURN_RIGHT`
// , composer: (10fr, 9fr)
#slide(title: "Proposed Environment Formulation")[
  // #set align(horizon)
  #set text(.9em)
  Our environment is only *partially observable*.
  - *State space:* possible agent positions in the room:\
    $#state_space subset RR^2 times [0, 2 pi]$
  - *Observation space:* Spectral representation\ of recorded audio:\
    $Omega subset CC^(C times F times T)$
  - *Action space:* $#action_space = \{ #a-stay, #a-forward, #a-left, #a-right \}$
  - *Reward:* decreasing function of the WER:

  #place(top + right, image("figures/rl_schema_2.svg", width: 19em))

  $
    #text(reward_color)[$r_t$] = cases(
      -mu_W & quad "if the agent tries to hit a wall",
      mu_C exp(- xi_C #C_t)
      - mu_m bb(1) (a_t = #a-forward) & quad "otherwise"
    )
  $

  // #place(auto, float: true, scope: "column", dx: 6em, dy: 0em)[
  //   #set text(size: .9em)
  //   $
  //     #text(reward_color)[$r_t$] = cases(
  //       -mu_W & quad "if the agent tries to hit a wall",
  //       mu_C exp(- xi_C #C_t)
  //       - mu_m bb(1) (a_t = #a-forward) & quad "otherwise"
  //     )
  //   $
  // ]
]
// [
//   // #set align(top)
//   #v(-10.5em)
//   #image("figures/rl_schema_2.svg", width: 100%)
// ]


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
