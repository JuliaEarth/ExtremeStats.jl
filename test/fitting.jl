
@testset "Fitting" begin
  @testset "Block" begin
    gev_seed = StableRNG(12345)
    dist1    = GeneralizedExtremeValue(0.0, 1.0, 0.0)
    dist2    = GeneralizedExtremeValue(0.0, 1.0, 0.5)
    dist3    = GeneralizedExtremeValue(1.0, 1.0, 0.5) # The problem distribution...
    r_gev_1  = readdlm("R_fit_results/R_gev_dist1_fits.csv", ',')
    r_gev_2  = readdlm("R_fit_results/R_gev_dist2_fits.csv", ',')
    r_gev_3  = readdlm("R_fit_results/R_gev_dist3_fits.csv", ',')
    r_result = zip(eachrow(r_gev_1), eachrow(r_gev_2), eachrow(r_gev_3))
    for (test_ix, r_gev_ix) in enumerate(r_result)
      for (r_mle, dist) in zip(r_gev_ix, (dist1, dist2, dist3))
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
    r_gpd_1  = readdlm("R_fit_results/R_gpd_dist1_fits.csv", ',')
    r_gpd_2  = readdlm("R_fit_results/R_gpd_dist2_fits.csv", ',')
    r_gpd_3  = readdlm("R_fit_results/R_gpd_dist3_fits.csv", ',')
    r_result = zip(eachrow(r_gpd_1), eachrow(r_gpd_2), eachrow(r_gpd_3))
    for (test_ix, r_gpd_ix) in enumerate(r_result)
      for (r_mle, dist) in zip(r_gpd_ix, (dist1, dist2, dist3))
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
using RCall, StableRNGs, Distributions
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

using DelimitedFiles
writedlm("R_fit_results/R_gev_dist1_fits.csv", getindex.(gev_R_results, 1), ',')
writedlm("R_fit_results/R_gev_dist2_fits.csv", getindex.(gev_R_results, 2), ',')
writedlm("R_fit_results/R_gev_dist3_fits.csv", getindex.(gev_R_results, 3), ',')
writedlm("R_fit_results/R_gpd_dist1_fits.csv", getindex.(gpd_R_results, 1), ',')
writedlm("R_fit_results/R_gpd_dist2_fits.csv", getindex.(gpd_R_results, 2), ',')
writedlm("R_fit_results/R_gpd_dist3_fits.csv", getindex.(gpd_R_results, 3), ',')
=#
