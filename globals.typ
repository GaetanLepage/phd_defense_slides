// #import "@preview/touying:0.6.1": *
#import "/touying/lib.typ": *
#import themes.metropolis: *
#import "@preview/subpar:0.2.2"

#let todo(body) = {
  set text(maroon)
  [*TODO:* #body]
}

#let anim_slide(n, image-prefix: "", title: "", image-height: 100%) = {
  slide(repeat: n, title: title, align: center, self => [
    #let (uncover, only, alternatives) = utils.methods(self)

    #for i in range(1, n + 1) {
      only(i)[
        #image(
          image-prefix + str(i) + ".svg",
          height: image-height,
        )
      ]
    }
  ])
}

/* TABLES */
#let toprule = table.hline()
#let bottomrule = toprule
#let midrule = table.hline(stroke: 0.05em)
#let dashedrule = table.hline(stroke: (dash: "dashed", thickness: 0.05em))

#let mk-header(text) = table.cell(colspan: 2)[#align(center)[#text]]
#let header-pred-spectrum = mk-header[Estimated DoA spectrum $hat(o)_t$]
#let header-gt-spectrum = mk-header[Ground truth DoA spectrum $o_t$]

// Common headers
#let header-mae = [MAE (°) #sym.arrow.b]
#let header-acc = [Accuracy (%) #sym.arrow.t]
#let header-prec = [Precision (%) #sym.arrow.t]
#let header-recall = [Recall (%) #sym.arrow.t]

#let psi-dnn = $Psi_("DNN"(theta))$

// Metrics
#let mfc = $hat(C)_F$
#let mfd = $hat(D)_F$
#let mfae = $hat(theta)_F$
#let mean-cum-reward = $macron(R)$
#let n-ep = $n_"ep"$
