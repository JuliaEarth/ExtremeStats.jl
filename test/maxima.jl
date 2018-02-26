@testset "Maxima" begin
  maxima = BlockMaxima(1:100, 2)
  @test collect(maxima) == collect(2:2:100)

  maxima = PeakOverThreshold(1:100, 50.)
  @test collect(maxima) == collect(51:100)
end
