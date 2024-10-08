# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    returnlevels(xs)

Return periods and levels of data `xs`.
"""
function returnlevels(xs::AbstractVector)
  ms = sort(xs)
  n = length(ms)
  p = (1:n) ./ (n + 1)
  δt = 1 ./ (1 .- p)

  δt, ms
end

"""
    returnlevels(gev, mmin, mmax; nlevels=50)

Return `nlevels` periods and levels of generalized extreme
value distribution `gev` with maxima in the interval `[mmin,mmax]`.
"""
function returnlevels(gev::GeneralizedExtremeValue, mmin::Real, mmax::Real; nlevels::Int=50)
  ms = linspace(mmin, mmax, nlevels)
  δt = 1 ./ (1 .- cdf.(gev, ms))

  δt, ms
end

"""
    meanexcess(xs, k)

Return mean excess of the data `xs` using previous `k` values.
"""
meanexcess(xs::AbstractVector, k::Int) = meanexcess(xs, [k])[1]

function meanexcess(xs::AbstractVector, ks::AbstractVector{Int})
  ys = sort(xs, rev=true)
  [mean(log.(ys[1:(k - 1)])) - log(ys[k]) for k in ks]
end
