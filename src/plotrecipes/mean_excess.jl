# ------------------------------------------------------------------
# Copyright (c) 2018, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

@userplot ExcessPlot

@recipe function f(p::ExcessPlot)
  # get user input
  xs = p.args[1]

  ks = 2:length(xs)
  ξs = meanexcess(xs, ks)

  seriestype --> :path
  xlabel --> "number of maxima"
  ylabel --> "extreme value index"

  ks, ξs
end
