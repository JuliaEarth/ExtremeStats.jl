@testset "Pareto quantile" begin
  if ismaintainer || istravis
    @testset "Plot recipe" begin
      function plot_pareto_quantile(fname)
        plt1 = paretoplot(data₁, label="Lognormal")
        plt2 = paretoplot(data₂, label="Pareto")
        plot(plt1, plt2, size=(600,800), layout=(2,1))
        png(fname)
      end
      refimg = joinpath(datadir,"ParetoQuantile.png")
      @test test_images(VisualTest(plot_pareto_quantile, refimg), popup=!istravis, tol=0.1) |> success
    end
  end
end
