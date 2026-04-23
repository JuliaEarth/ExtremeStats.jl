# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

module ExtremeStats

using Distributions
using JuMP, Ipopt

# implement fitting methods
import Distributions: fit_mle

include("maxima.jl")
include("fitting.jl")
include("plotting.jl")
include("stats.jl")

export
  # maxima types
  BlockMaxima,
  PeakOverThreshold,

  # plots
  excessplot,
  excessplot!,
  paretoplot,
  paretoplot!,
  returnplot,
  returnplot!,

  # statistics
  returnlevels,
  meanexcess

end
