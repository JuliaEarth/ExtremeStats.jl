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

srand(2018)

# test samples
data₁ = rand(LogNormal(2, 2), 5000)
data₂ = rand(Pareto(.9, 10), 5000)

# list of tests
testfiles = [
  "maxima.jl",
  "return_levels.jl",
  "mean_excess.jl"
]

@testset "ExtremeStats.jl" begin
  for testfile in testfiles
    include(testfile)
  end
end
