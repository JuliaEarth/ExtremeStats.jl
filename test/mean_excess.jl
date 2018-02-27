@testset "Mean excess" begin
  if ismaintainer || istravis
    @testset "Plot recipe" begin
      function plot_mean_excess(fname)
        plt1 = excessplot(data₁, label="Lognormal")
        plt2 = excessplot(data₂, label="Pareto")
        plot(plt1, plt2, size=(600,800), layout=(2,1))
        png(fname)
      end
      refimg = joinpath(datadir,"MeanExcess.png")
      @test test_images(VisualTest(plot_mean_excess, refimg), popup=!istravis) |> success
    end
  end
end
