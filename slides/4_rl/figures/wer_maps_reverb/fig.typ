#import "/globals.typ": *

#let height = 40%
#let width = 40%

// #grid(columns: 2, gutter: 1em, row-gutter: 0em,)[
//   #image("wer_map_200ms.svg", height: height)
// ][$T_(60) = 200$ms][
//   #image("wer_map_500ms.svg", height: height)
// ][$T_(60) = 500$ms][
//   #image("wer_map_800ms.svg", height: height)
// ][$T_(60) = 800$ms]

#subpar.grid(
  figure(image("wer_map_200ms.svg", height: height), caption: [
    $T_(60) = 200"ms"$.
  ]),

  figure(image("wer_map_500ms.svg", height: height), caption: [
    $T_(60) = 500"ms"$.
  ]),

  figure(image("wer_map_800ms.svg", height: height), caption: [
    $T_(60) = 800"ms"$.
  ]),

  columns: 3,
)
