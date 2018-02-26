# ------------------------------------------------------------------
# Copyright (c) 2018, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

@userplot ReturnPlot

@recipe function f(rp::ReturnPlot)
  # get user input
  maxima = rp.args[1]

  vals = sort(collect(maxima))

  n = length(vals)
  p = (1:n) / (n+1)
  T = 1 ./ (1 - p)

  seriestype --> :scatter
  xscale --> :log10
  xlabel --> "return period"
  ylabel --> "return level"
  label --> "$n maxima"

  T, vals
end
