# ------------------------------------------------------------------
# Copyright (c) 2018, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    return_levels(maxima)

Return periods and levels of `maxima`.
"""
function return_levels(maxima::AbstractMaxima)
  ms = sort(collect(maxima))
  n = length(ms)
  p = (1:n) / (n + 1)
  Δt = 1 ./ (1 - p)

  Δt, ms
end

"""
    return_levels(gev, mmin, mmax; nlevels=50)

Return `nlevels` periods and levels of generalized extreme
value distribution `gev` with maxima in the interval `[mmin,mmax]`.
"""
function return_levels(gev::GeneralizedExtremeValue,
                       mmin::Real, mmax::Real;
                       nlevels::Int=50)
  ms = linspace(mmin, mmax, nlevels)
  Δt = 1 ./ (1 - cdf.(gev, ms))

  Δt, ms
end
