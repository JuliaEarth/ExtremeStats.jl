# ------------------------------------------------------------------
# Copyright (c) 2018, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

@userplot ReturnPlot

@recipe function f(rp::ReturnPlot)
  # get user input
  obj = rp.args[1]

  if obj isa AbstractVector
    seriestype --> :scatter
    δt, ms = returnlevels(obj)
  elseif obj isa GeneralizedExtremeValue
    seriestype --> :path
    mmin, mmax = rp.args[2:3]
    δt, ms = returnlevels(obj, mmin, mmax)
  end

  xscale --> :log10
  xlabel --> "return period"
  ylabel --> "return level"
  label  --> "return plot"

  δt, ms
end
