if visualtests
  @testset "Plot recipes" begin
    Random.seed!(2018)
    data₁ = rand(LogNormal(2, 2), 5000)
    data₂ = rand(Pareto(.9, 10), 5000)

    Random.seed!(2018)
    xs = rand(LogNormal(0, 1), 5000)

    @testset "Return levels" begin
      @test_reference "data/ReturnLevels.png" returnplot(xs,label="log-normal")
    end

    @testset "Mean excess" begin
      plt1 = excessplot(data₁, label="Lognormal")
      plt2 = excessplot(data₂, label="Pareto")
      plt = plot(plt1, plt2, size=(600,800), layout=(2,1))
      @test_reference "data/MeanExcess.png" plt
    end

    @testset "Pareto quantile" begin
      plt1 = paretoplot(data₁, label="Lognormal")
      plt2 = paretoplot(data₂, label="Pareto")
      plt = plot(plt1, plt2, size=(600,800), layout=(2,1))
      @test_reference "data/ParetoQuantile.png" plt
    end
  end
end
