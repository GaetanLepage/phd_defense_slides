#import "/imports/touying.typ": *

#import "@preview/numbly:0.1.0": numbly

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  footer: self => self.info.institution,
  config-info(
    title: [
      From Sound to Action:\
      Deep Learning for Audio-Based Localization and Navigation in Robotics
    ],
    subtitle: [PhD defense],
    author: [Gaétan Lepage],
    //date: datetime.today(),
    date: "July 15, 2025",
    institution: [Université Grenoble Alpes],
    logo: image("assets/logo_uga.svg"),
  ),
  config-colors(
    primary: rgb("#eb811b"),
    primary-light: rgb("#d6c6b7"),
    secondary: rgb("#23373b"),
    neutral-lightest: rgb("#fafafa"),
    neutral-dark: rgb("#23373b"),
    neutral-darkest: rgb("#23373b"),
  ),
)


#set heading(
  numbering: numbly(
    "{1}.",
    default: "1.1",
  ),
)

#title-slide()

#include "slides/0_index.typ"
