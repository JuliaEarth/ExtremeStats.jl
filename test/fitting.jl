
@testset "Fitting" begin
  @testset "Block" begin
    rng_seed = StableRNG(12345)
    dist1    = GeneralizedExtremeValue(0.0, 1.0, 0.0)
    dist2    = GeneralizedExtremeValue(0.0, 1.0, 0.5)
    dist3    = GeneralizedExtremeValue(1.0, 1.0, 0.5)
    R"""
    install.packages('ismev', repos='http://cran.us.r-project.prg')
    library(ismev)
    """
    for test_ix in 1:10
      for dist in (dist1, dist2, dist3)
        sample = rand(dist, 1000)
        julia_fit = fit(GeneralizedExtremeValue, BlockMaxima(sample, 1))
        R"""
          r_fit = gev.fit($sample, show=FALSE)
          r_mle = r_fit$mle
        """
        r_mle = @rget r_mle
        j_mle = [julia_fit.μ, julia_fit.σ, julia_fit.ξ]
        @test isapprox(j_mle, r_mle, atol=1e-3)
      end
    end
  end

  @testset "PoT" begin
    rng_seed = StableRNG(12345)
    dist1    = GeneralizedPareto(0.0, 1.0, 0.0)
    dist2    = GeneralizedPareto(0.0, 1.0, 0.5)
    dist3    = GeneralizedPareto(1.0, 1.0, 0.5)
    R"""
    install.packages('ismev', repos='http://cran.us.r-project.prg')
    library(ismev)
    """
    for test_ix in 1:10
      for dist in (dist1, dist2, dist3)
        sample = rand(dist, 1000)
        julia_fit = fit(GeneralizedPareto, PeakOverThreshold(sample, dist.μ))
        R"""
          r_fit = gpd.fit($sample, threshold=$(dist.μ), show=FALSE)
          r_mle = r_fit$mle
        """
        r_mle = @rget r_mle
        j_mle = [julia_fit.μ, julia_fit.σ, julia_fit.ξ]
        @test isapprox(j_mle, r_mle, atol=1e-3)
      end
    end
  end
end

