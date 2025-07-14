#import "@preview/cetz:0.3.2"
#import "@preview/cetz-plot:0.1.1": plot

#let d(x) = calc.pi - calc.abs(calc.abs(x) - calc.pi)
#let sigma_2 = calc.pow(
  (8 * calc.pi / 180),
  2,
)
#let gaussian(x, sigma_2) = calc.exp(
  -(
    calc.pow(d(x), 2) / sigma_2
  ),
)
#let gt_1 = -1.0
#let gt_2 = 2.2
#let gt_3 = 4.2
#let gt_gaussian_1(x) = gaussian(x + gt_1, sigma_2)
#let gt_gaussian_2(x) = gaussian(x + gt_2, sigma_2)
#let gt_gaussian_3(x) = gaussian(x + gt_3, sigma_2)
#let gt-func(x) = calc.max(gt_gaussian_1(x), gt_gaussian_2(x), gt_gaussian_3(x))
// #let pred_1 = gt_1 + 0.2
#let pred_2 = gt_2 - 0.1
#let pred_3 = gt_3 + 0.05
#let pred(x, coef, shift, sigma_2) = coef * gaussian(x + shift, sigma_2)
#let pred_gaussian_1(x) = pred(x, 0.8, gt_1 + 0.2, 2 * sigma_2)
#let pred_gaussian_2(x) = pred(x, 0.7, gt_2 - 0.1, 3 * sigma_2)
#let pred_gaussian_3(x) = pred(x, 0.3, 1.0, 0.7 * sigma_2)
#let pred_gaussian_4(x) = pred(x, 0.1, 0.3, 0.1 * sigma_2)
#let pred_gaussian_5(x) = pred(x, 0.9, pred_3, 0.3 * sigma_2)
#let network(x) = calc.max(
  pred_gaussian_1(x),
  pred_gaussian_2(x),
  pred_gaussian_3(x),
  pred_gaussian_4(x),
  pred_gaussian_5(x),
)

#cetz.canvas({
  import cetz.draw: *
  plot.plot(
    size: (14, 3),
    x-tick-step: none,
    x-ticks: ((-calc.pi, $-pi$), (0, $0$), (calc.pi, $pi$)),
    y-tick-step: 1,
    y-max: 1.2,
    // y-label: $o(theta)$,
    y-label: "",
    x-label: $theta$,
    {
      plot.add(
        hypograph: true,
        style: (
          fill: rgb(0, 0, 200, 75),
          stroke: black,
        ),
        domain: (-calc.pi, calc.pi),
        gt-func,
        samples: 1000,
      )
      plot.add(
        hypograph: true,
        style: (
          fill: red,
          stroke: black,
        ),
        domain: (-calc.pi, calc.pi),
        network,
        samples: 1000,
      )
    },
  )
})
