using ExtremeStats
using Distributions
using Plots; gr(size=(600,400))
using Base.Test
using VisualRegressionTests

# setup GR backend for Travis CI
ENV["GKSwstype"] = "100"
ENV["PLOTS_TEST"] = "true"

# list of maintainers
maintainers = ["juliohm"]

# environment settings
istravis = "TRAVIS" ∈ keys(ENV)
ismaintainer = "USER" ∈ keys(ENV) && ENV["USER"] ∈ maintainers
datadir = joinpath(@__DIR__,"data")

# test samples
lognorm = rand(LogNormal(2, 2), 5000)
pareto  = rand(Pareto(.9, 10), 5000)

# list of tests
testfiles = [
  "maxima.jl",
  "return_levels.jl"
]

@testset "ExtremeStats.jl" begin
  for testfile in testfiles
    include(testfile)
  end
end
