# ------------------------------------------------------------------
# Copyright (c) 2018, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    returnlevels(maxima)

Return periods and levels of `maxima`.
"""
function returnlevels(maxima::AbstractMaxima)
  ms = sort(collect(maxima))
  n = length(ms)
  p = (1:n) / (n + 1)
  δt = 1 ./ (1 - p)

  δt, ms
end

"""
    returnlevels(gev, mmin, mmax; nlevels=50)

Return `nlevels` periods and levels of generalized extreme
value distribution `gev` with maxima in the interval `[mmin,mmax]`.
"""
function returnlevels(gev::GeneralizedExtremeValue,
                      mmin::Real, mmax::Real;
                      nlevels::Int=50)
  ms = linspace(mmin, mmax, nlevels)
  δt = 1 ./ (1 - cdf.(gev, ms))

  δt, ms
end
