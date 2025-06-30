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

#slide(title: "Challenges of Auditory Perception in Robotics", composer: (1fr, 2fr))[
  #todo[Add image(s)]
][
  - Humans mainly communicate through speech
    #pause
  - Robots must properly understand humans to have relevant interactions
    #pause
  - Sound can also be used to localize speakers
]

#slide(title: "Learning Robot Behaviors", composer: (1fr, 2fr))[
  #todo[Add image(s)]
][
  - Robots need to react to their environment and take actions
  - Several objectives and constraints can be described
]


==

---

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
