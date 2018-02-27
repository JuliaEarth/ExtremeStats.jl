# ------------------------------------------------------------------
# Copyright (c) 2018, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

__precompile__()

module ExtremeStats

using Distributions
using JuMP, Ipopt
using RecipesBase

# implement fitting methods
import Distributions: fit_mle

include("maxima.jl")
include("fitting.jl")

# plot recipes
include("plotrecipes/return_levels.jl")
include("plotrecipes/mean_excess.jl")

export
  # maxima types
  BlockMaxima,
  PeakOverThreshold

end
