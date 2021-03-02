
@testset "Fitting" begin
  @testset "Block" begin
    gev_seed = StableRNG(12345)
    dist1    = GeneralizedExtremeValue(0.0, 1.0, 0.0)
    dist2    = GeneralizedExtremeValue(0.0, 1.0, 0.5)
    dist3    = GeneralizedExtremeValue(1.0, 1.0, 0.5) # The problem distribution...
    r_gev    = deserialize("R_gev_fits.serialized")
    for test_ix in 1:10
      for (r_mle, dist) in zip(r_gev[test_ix], (dist1, dist2, dist3))
        sample = rand(gev_seed, dist, 1000)
        try
          julia_fit = fit(GeneralizedExtremeValue, BlockMaxima(sample, 1))
          j_mle = [julia_fit.μ, julia_fit.σ, julia_fit.ξ]
          @test isapprox(j_mle, r_mle, atol=1e-3)
        catch er
          @info "Optimization failed for $dist on trial $test_ix with error $er."
        end
      end
    end
  end

  @testset "PoT" begin
    gpd_seed = StableRNG(12345)
    dist1    = GeneralizedPareto(0.0, 1.0, 0.0)
    dist2    = GeneralizedPareto(0.0, 1.0, 0.5)
    dist3    = GeneralizedPareto(1.0, 1.0, 0.5)
    r_gpd    = deserialize("R_gpd_fits.serialized")
    for test_ix in 1:10
      for (r_mle, dist) in zip(r_gpd[test_ix], (dist1, dist2, dist3))
        sample = rand(gpd_seed, dist, 1000)
        try
          julia_fit = fit(GeneralizedPareto, PeakOverThreshold(sample, dist.μ))
          j_mle     = [julia_fit.σ, julia_fit.ξ]
          @test isapprox(j_mle, r_mle, atol=1e-3)
        catch er
          @info "Optimization failed for $dist on trial $test_ix with error $er."
        end
      end
    end
  end
end

#= Code to generate the R test files:
using RCall, StableRNGs, ExtremeStats, Distributions
R"library(ismev)"
gev_R_results = NTuple{3, Vector{Float64}}[]
gev_seed = StableRNG(12345)
dist1    = GeneralizedExtremeValue(0.0, 1.0, 0.0)
dist2    = GeneralizedExtremeValue(0.0, 1.0, 0.5)
dist3    = GeneralizedExtremeValue(1.0, 1.0, 0.5)
for test_ix in 1:10
  mles_trialj = map((dist1, dist2, dist3)) do dist
    sample = rand(gev_seed, dist, 1000)
    R"""
      r_fit = gev.fit($sample, show=FALSE)
      r_mle = r_fit$mle
    """
    @rget r_mle
  end
  push!(gev_R_results, mles_trialj)
end

gpd_R_results = NTuple{3, Vector{Float64}}[]
gpd_seed = StableRNG(12345)
dist1    = GeneralizedPareto(0.0, 1.0, 0.0)
dist2    = GeneralizedPareto(0.0, 1.0, 0.5)
dist3    = GeneralizedPareto(1.0, 1.0, 0.5)
for test_ix in 1:10
  mles_trialj = map((dist1, dist2, dist3)) do dist
    sample = rand(gpd_seed, dist, 1000)
    R"""
      r_fit = gpd.fit($sample, threshold=$(dist.μ), show=FALSE)
      r_mle = r_fit$mle
    """
    @rget r_mle
  end
  push!(gpd_R_results, mles_trialj)
end

using Serialization
serialize("R_gev_fits.serialized", gev_R_results)
serialize("R_gpd_fits.serialized", gpd_R_results)
=#
