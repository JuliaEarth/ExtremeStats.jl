@testset "Return levels" begin
  Random.seed!(2018)
  xs = rand(LogNormal(0, 1), 5000)

  if ismaintainer || istravis
    @testset "Plot recipe" begin
      function plot_return_levels(fname)
        returnplot(xs, label="log-normal")
        png(fname)
      end
      refimg = joinpath(datadir,"ReturnLevels.png")
      @test test_images(VisualTest(plot_return_levels, refimg), popup=!istravis) |> success
    end
  end
end
