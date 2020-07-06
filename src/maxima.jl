# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    AbstractMaxima

A collection of maxima (e.g. block maxima)
"""
abstract type AbstractMaxima end

"""
    collect(maxima)

Collect `maxima` values using appropriate model.
"""
Base.collect(m::AbstractMaxima) = error("not implemented")

#------------------
# IMPLEMENTATIONS
#------------------
"""
    BlockMaxima(x, n)

Maxima obtained by splitting the data `x` into blocks of size `n`.
"""
struct BlockMaxima{V<:AbstractVector} <: AbstractMaxima
  x::V
  n::Int
end

function Base.collect(m::BlockMaxima)
  result = Vector{Float64}()
  for i in 1:m.n:length(m.x)-m.n+1
    xs = skipmissing(view(m.x, i:i+m.n-1))

    xmax = -Inf
    for x in xs
      x > xmax && (xmax = x)
    end

    isinf(xmax) || push!(result, xmax)
  end

  result
end

"""
    PeakOverThreshold(x, u)

Maxima obtained by thresholding the data `x` with threshold `u`.
"""
struct PeakOverThreshold{V<:AbstractVector} <: AbstractMaxima
  x::V
  u::Float64
end

Base.collect(m::PeakOverThreshold) = filter(x -> !ismissing(x) && x > m.u, m.x)
