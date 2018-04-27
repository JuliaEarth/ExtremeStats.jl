# ------------------------------------------------------------------
# Copyright (c) 2018, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

@userplot ReturnPlot

@recipe function f(rp::ReturnPlot)
  # get user input
  obj = rp.args[1]

  if obj isa AbstractMaxima
    seriestype --> :scatter
    levels = sort(collect(obj))
    n = length(levels)
    p = (1:n) / (n + 1)
    Δt = 1 ./ (1 - p)
  elseif obj isa GeneralizedExtremeValue
    seriestype --> :path
    a, b = rp.args[2:3]
    levels = linspace(a, b)
    Δt = 1 ./ (1 - cdf.(obj, levels))
  end

  xscale --> :log10
  xlabel --> "return period"
  ylabel --> "return level"
  label --> "return plot"

  Δt, levels
end
