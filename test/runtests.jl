using ExtremeStats
using Distributions
using StableRNGs
using DelimitedFiles
using ReferenceTests
using CairoMakie
using Test

# environment settings
isCI = "CI" ∈ keys(ENV)
islinux = Sys.islinux()
visualtests = !isCI || (isCI && islinux)
datadir = joinpath(@__DIR__, "data")

# list of tests
testfiles = ["maxima.jl", "fitting.jl", "plotting.jl"]

@testset "ExtremeStats.jl" begin
  for testfile in testfiles
    include(testfile)
  end
end
