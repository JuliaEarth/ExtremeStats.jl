using ExtremeStats
using Distributions
using Plots
using VisualRegressionTests
using Test, Pkg, Random

# environment settings
islinux = Sys.islinux()
istravis = "TRAVIS" ∈ keys(ENV)
datadir = joinpath(@__DIR__,"data")
visualtests = !istravis || (istravis && islinux)
if !istravis
  Pkg.add("Gtk")
  using Gtk
end

# list of tests
testfiles = [
  "maxima.jl",
  "fitting.jl",
  "plotrecipes.jl"
]

@testset "ExtremeStats.jl" begin
  for testfile in testfiles
    include(testfile)
  end
end
