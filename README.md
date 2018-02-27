# ExtremeStats.jl

*Extreme Value Statistics in Julia*

[![][travis-img]][travis-url] [![][julia-pkg-img]][julia-pkg-url] [![][codecov-img]][codecov-url]

This package provides a set of tools for analysing and estimating extreme value distributions.
It defines two types, `BlockMaxima` and `PeakOverThreshold`, which can be used to filter a
collection of values into a collection of maxima.

Given a collection of maxima produced by either model above, one can start estimating heavy-tail
distributions and plotting classical extreme value statistics.

## Installation

Get the latest stable release with Julia's package manager:

```julia
Pkg.add("ExtremeStats")
```

## Usage

Given a collection of values `xs` (e.g. time series), one can retrieve its maxima:

```julia
using ExtremeStats

# find maxima with blocks of size 50
bm = BlockMaxima(xs, 50)

# get values above a threshold of 100.
pm = PeakOverThreshold(xs, 100.)
```

For the block maxima model, the values `xs` need to represent a measurement over time,
whereas the peak over threshold model does not assume any ordering in the data.

### Plotting

A few plot recipes are defined for maxima:

```julia
using Plots

# return level plot
returnplot(bm)
```

### Fitting

Generalized extreme value (GEV) distributions from the `Distributions.jl` package can be fit
to maxima via constrained optimization (maximum likelihood + extreme value index constraints):

```julia
using Distributions

# TODO
```

## References

TODO

[travis-img]: https://travis-ci.org/juliohm/ExtremeStats.jl.svg?branch=master
[travis-url]: https://travis-ci.org/juliohm/ExtremeStats.jl

[julia-pkg-img]: http://pkg.julialang.org/badges/ExtremeStats_0.6.svg
[julia-pkg-url]: http://pkg.julialang.org/?pkg=ExtremeStats

[codecov-img]: https://codecov.io/gh/juliohm/ExtremeStats.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/juliohm/ExtremeStats.jl