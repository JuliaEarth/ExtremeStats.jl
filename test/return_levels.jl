@testset "Return levels" begin
  srand(2018)
  x = rand(LogNormal(0, 1), 5000)
  bmaxima = BlockMaxima(x, 50)
  pmaxima = PeakOverThreshold(x, 5.)

  if ismaintainer || istravis
    @testset "Plot recipe" begin
      function plot_return_levels(fname)
        plt1 = returnplot(bmaxima, label="block maxima")
        plt2 = returnplot(pmaxima, label="peak over threshold")
        plot(plt1, plt2, size=(600,800), layout=(2,1))
        png(fname)
      end
      refimg = joinpath(datadir,"ReturnLevels.png")
      @test test_images(VisualTest(plot_return_levels, refimg), popup=!istravis) |> success
    end
  end
end
