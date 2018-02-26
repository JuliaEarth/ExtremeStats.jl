# ------------------------------------------------------------------
# Copyright (c) 2018, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

__precompile__()

module ExtremeStats

using Distributions
using RecipesBase

include("maxima.jl")

# plot recipes
include("plotrecipes/return_levels.jl")

export
  # maxima types
  BlockMaxima,
  PeakOverThreshold

end
