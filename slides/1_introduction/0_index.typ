#import "/globals.typ": *

= Introduction

#slide(title: "Social Robotics", composer: (1fr, 2fr))[
  #figure(image("figures/ari.png"), caption: "The ARI robot, PAL robotics", numbering: none)
][
  #set text(size: .9em)
  - Social robotics aims to build capable robotic agents.
  - They must *collaborate with humans* (social acceptance, etc.)
  - *Human Robot Interactions* entail a wide range of challenges
    #pause
  - Key challenges:
    - *Perception:* Extract relevant information from _multi-modal data_ captured by diverse sensors
    - *Action:* Learn relevant policies to achieve desirable behaviors (navigation, grasping, conversation, etc.)
]

#slide(title: "Challenges of Auditory Perception in Robotics", composer: (2fr, 1fr))[
  // #{
  //   set align(center)
  //   stack(dir: ltr, spacing: 1em, image("figures/interaction.png", height: 40%), image(
  //     "figures/interaction.png",
  //     height: 40%,
  //   ))
  // }

  - Humans mainly communicate through speech
  - Robots must properly understand humans to have relevant interactions
  - Sound can also be used to localize speakers

  - Core acoustic tasks in robotics:
    - Automatic Speech Recognition (ASR) @malik2021automatic
    - Sound Source Localization (SSL) @argentieri2015survey@grumiaux2022survey
    - Conversational Speech Generation @defossez2024moshi
][
  #image("figures/interaction.png")
]

#slide(title: "Learning Robot Behaviors", composer: (1fr, 2fr))[
  #image("figures/navigation.png")
][
  #set text(size: .9em)
  Robots need to react to their environment and take actions
  - React dynamically to the environment
  - Accomplish interactive or collaborative tasks @majumder2021move2hear @lathuiliere2019neural
  - Several objectives and constraints can be described

  Challenges:
  - Designing tractable objectives for robots behavior
  - Ensuring humans safety @zacharaki2020safety
  - Making robots _socially accepted_ by humans? @ottoni2024systematic
  - Detecting and reacting to external events?
  - Learning flexible policies
]

#slide(title: "Plan", align: center + horizon)[
  #image("figures/outline.svg", height: 90%)
]

// // TODO: show this between each section
// #show outline.entry: it => link(
//   it.element.location(),
//   // Keep just the body, dropping
//   // the fill and the page.
//   it.indented(it.prefix(), it.body()),
// )
//
// #components.adaptive-columns(outline(indent: 1em, depth: 1))
