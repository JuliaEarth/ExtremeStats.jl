using ExtremeStats
using Distributions
using StableRNGs
using DelimitedFiles
using Plots;
gr(size=(600, 400));
using ReferenceTests, ImageIO
using Test, Random

# workaround GR warnings
ENV["GKSwstype"] = "100"

# environment settings
isCI = "CI" ∈ keys(ENV)
islinux = Sys.islinux()
visualtests = !isCI || (isCI && islinux)
datadir = joinpath(@__DIR__, "data")

# list of tests
testfiles = ["maxima.jl", "fitting.jl", "plotrecipes.jl"]

@testset "ExtremeStats.jl" begin
  for testfile in testfiles
    include(testfile)
  end
end
