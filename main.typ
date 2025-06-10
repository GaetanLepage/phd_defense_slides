#import "@preview/touying:0.6.1": *
#import themes.metropolis: *

#import "@preview/numbly:0.1.0": numbly

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  footer: self => self.info.institution,
  config-info(
    title: [
      From Sound to Action: Deep Learning for Audio-Based Localization and Navigation in Robotics
    ],
    subtitle: [PhD defense],
    author: [Gaétan Lepage],
    //date: datetime.today(),
    date: "July 15, 2025",
    institution: [Université Grenoble Alpes],
    logo: image("assets/logo_uga.svg"),
  ),
)

#set heading(
  numbering: numbly("{1}.",
  default: "1.1")
)

#title-slide()