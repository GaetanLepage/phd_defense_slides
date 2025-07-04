#import "/globals.typ": *

#import "@preview/numbly:0.1.0": numbly
// #import "/touying/lib.typ": *
#import themes.metropolis: *

#let bib = bibliography("bibliography.bib", title: none)
#let orange = rgb("#eb811b")

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  // footer: self => self.info.institution,
  config-info(
    title: [
      From Sound to Action:
      Deep Learning for Audio-Based Localization and Navigation in Robotics
    ],
    // subtitle: [PhD defense],
    author: [Gaétan Lepage],
    //date: datetime.today(),
    date: "July 15, 2025",
    // institution: [Université Grenoble Alpes],
    // logo: image("assets/logo_uga.svg"),
  ),
  config-colors(
    primary: orange,
    primary-light: rgb("#d6c6b7"),
    secondary: rgb("#23373b"),
    neutral-lightest: rgb("#fafafa"),
    neutral-dark: rgb("#23373b"),
    neutral-darkest: rgb("#23373b"),
  ),
  config-common(
    new-section-slide-fn: none,
    // show-strong-with-alert: false,
    show-bibliography-as-footnote: bib,
  ),
)

// Do not number figures
#set figure(numbering: none)

#set super(size: 1em, baseline: 0em)
#show super: it => {
  text(orange)[#it]
}


#set heading(numbering: numbly(
  "{1}.",
  default: "1.1",
))

#title-slide()

#include "slides/0_index.typ"
#focus-slide[Thank you!]
