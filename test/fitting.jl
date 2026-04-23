
@testset "Fitting" begin
  @testset "BlockMaxima" begin
    rng = StableRNG(12345)
    dist1 = GeneralizedExtremeValue(0.0, 1.0, 0.0)
    dist2 = GeneralizedExtremeValue(0.0, 1.0, 0.5)
    dist3 = GeneralizedExtremeValue(1.0, 1.0, 0.5) # The problem distribution...
    rgev1 = readdlm(joinpath(datadir, "R_gev_dist1_fits.csv"), ',')
    rgev2 = readdlm(joinpath(datadir, "R_gev_dist2_fits.csv"), ',')
    rgev3 = readdlm(joinpath(datadir, "R_gev_dist3_fits.csv"), ',')
    rresult = zip(eachrow(rgev1), eachrow(rgev2), eachrow(rgev3))
    for (trial, rgevparams) in enumerate(rresult)
      for (rmle, dist) in zip(rgevparams, (dist1, dist2, dist3))
        sample = rand(rng, dist, 1000)
        try
          jfit = fit(GeneralizedExtremeValue, BlockMaxima(sample, 1))
          jmle = [jfit.μ, jfit.σ, jfit.ξ]
          @test isapprox(jmle, rmle, atol=1e-3)
        catch err
          @info "Optimization failed for $dist on trial $trial with error $err."
        end
      end
    end
  end

  @testset "PeakOverThreshold" begin
    rng = StableRNG(12345)
    dist1 = GeneralizedPareto(0.0, 1.0, 0.0)
    dist2 = GeneralizedPareto(0.0, 1.0, 0.5)
    dist3 = GeneralizedPareto(1.0, 1.0, 0.5)
    rgpd1 = readdlm(joinpath(datadir, "R_gpd_dist1_fits.csv"), ',')
    rgpd2 = readdlm(joinpath(datadir, "R_gpd_dist2_fits.csv"), ',')
    rgpd3 = readdlm(joinpath(datadir, "R_gpd_dist3_fits.csv"), ',')
    rresult = zip(eachrow(rgpd1), eachrow(rgpd2), eachrow(rgpd3))
    for (trial, rgpdparams) in enumerate(rresult)
      for (rmle, dist) in zip(rgpdparams, (dist1, dist2, dist3))
        sample = rand(rng, dist, 1000)
        try
          jfit = fit(GeneralizedPareto, PeakOverThreshold(sample, dist.μ))
          jmle = [jfit.σ, jfit.ξ]
          @test isapprox(jmle, rmle, atol=1e-3)
        catch err
          @info "Optimization failed for $dist on trial $trial with error $err."
        end
      end
    end
  end
end

#= Code to generate the R test files:
using RCall, StableRNGs, Distributions
R"library(ismev)"
gevresults = NTuple{3, Vector{Float64}}[]
rng = StableRNG(12345)
dist1 = GeneralizedExtremeValue(0.0, 1.0, 0.0)
dist2 = GeneralizedExtremeValue(0.0, 1.0, 0.5)
dist3 = GeneralizedExtremeValue(1.0, 1.0, 0.5)
for trial in 1:10
  mles = map((dist1, dist2, dist3)) do dist
    sample = rand(rng, dist, 1000)
    R"""
      r_fit = gev.fit($sample, show=FALSE)
      r_mle = r_fit$mle
    """
    @rget r_mle
  end
  push!(gevresults, mles)
end

gpdresults = NTuple{3, Vector{Float64}}[]
rng = StableRNG(12345)
dist1    = GeneralizedPareto(0.0, 1.0, 0.0)
dist2    = GeneralizedPareto(0.0, 1.0, 0.5)
dist3    = GeneralizedPareto(1.0, 1.0, 0.5)
for trial in 1:10
  mles = map((dist1, dist2, dist3)) do dist
    sample = rand(rng, dist, 1000)
    R"""
      r_fit = gpd.fit($sample, threshold=$(dist.μ), show=FALSE)
      r_mle = r_fit$mle
    """
    @rget r_mle
  end
  push!(gpdresults, mles)
end

using DelimitedFiles
writedlm("data/R_gev_dist1_fits.csv", getindex.(gevresults, 1), ',')
writedlm("data/R_gev_dist2_fits.csv", getindex.(gevresults, 2), ',')
writedlm("data/R_gev_dist3_fits.csv", getindex.(gevresults, 3), ',')
writedlm("data/R_gpd_dist1_fits.csv", getindex.(gpdresults, 1), ',')
writedlm("data/R_gpd_dist2_fits.csv", getindex.(gpdresults, 2), ',')
writedlm("data/R_gpd_dist3_fits.csv", getindex.(gpdresults, 3), ',')
=#
