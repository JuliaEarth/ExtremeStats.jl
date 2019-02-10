<p align="center">
  <img src="docs/ExtremeStats.png" height="200"><br>
  <a href="https://travis-ci.org/juliohm/ExtremeStats.jl">
    <img src="https://travis-ci.org/juliohm/ExtremeStats.jl.svg?branch=master">
  </a>
  <a href="https://codecov.io/gh/juliohm/ExtremeStats.jl">
    <img src="https://codecov.io/gh/juliohm/ExtremeStats.jl/branch/master/graph/badge.svg">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/license-ISC-blue.svg">
  </a>
</p>

This package provides a set of tools for analysing and estimating extreme value distributions.
It defines two types, `BlockMaxima` and `PeakOverThreshold`, which can be used to filter a
collection of values into a collection of maxima.

Given a collection of maxima produced by either model above, one can start estimating heavy-tail
distributions and plotting classical extreme value statistics.

## Installation

Get the latest stable release with Julia's package manager:

```julia
] add ExtremeStats
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

A few plot recipes are defined for maxima as well as for the original values `xs`:

```julia
using Plots

# mean excess plot
excessplot(xs)

# Pareto quantile plot
paretoplot(xs)

# return level plot
returnplot(xs)
```

### Fitting

Generalized extreme value (GEV) and generalized Pareto (GP) distributions from the `Distributions.jl` package can be fit
to maxima via constrained optimization (maximum likelihood + extreme value index constraints):

```julia
using Distributions

# fit GEV to block maxima
fit(GeneralizedExtremeValue, bm)

# fit GP to peak over threshold
fit(GeneralizedPareto, pm)
```

### Statistics

A few statistics are defined:

```julia
# return statistics
returnlevels(xs)

# mean excess with previous k values
meanexcess(xs, k)
```

## References

The book [An Introduction to Statistical Modeling of Extreme Values](http://www.springer.com/us/book/9781852334598)
by Stuart Coles gives a practical introduction to the theory. Most other books I've encountered are too theoretical
or expose topics that are somewhat disconnected.

[travis-img]: https://travis-ci.org/juliohm/ExtremeStats.jl.svg?branch=master
[travis-url]: https://travis-ci.org/juliohm/ExtremeStats.jl

[codecov-img]: https://codecov.io/gh/juliohm/ExtremeStats.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/juliohm/ExtremeStats.jl
