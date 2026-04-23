if visualtests
  @testset "Plotting" begin
    # gerenate random values
    rng = StableRNG(2026)
    xs = rand(rng, LogNormal(2, 2), 5000)
    ys = rand(rng, Pareto(0.9, 10), 5000)

    # mean excess plot
    fig = Figure(size=(1200, 400))
    ax1 = Axis(fig[1, 1], xlabel="Nᵒ of maxima", ylabel="Extreme value index (ξ)", title="LogNormal")
    ax2 = Axis(fig[1, 2], xlabel="Nᵒ of maxima", ylabel="Extreme value index (ξ)", title="Pareto")
    excessplot!(ax1, xs)
    excessplot!(ax2, ys)
    @test_reference joinpath(datadir, "excess.png") fig

    # Pareto quantile plot
    fig = Figure(size=(1200, 400))
    ax1 = Axis(fig[1, 1], xlabel="-log(i/(n+1))", ylabel="log(x⋆)", title="LogNormal")
    ax2 = Axis(fig[1, 2], xlabel="-log(i/(n+1))", ylabel="log(x⋆)", title="Pareto")
    paretoplot!(ax1, xs)
    paretoplot!(ax2, ys)
    @test_reference joinpath(datadir, "pareto.png") fig

    # return level plot
    fig = Figure(size=(1200, 400))
    ax1 = Axis(fig[1, 1], xlabel="Return period", ylabel="Return level", title="LogNormal", xscale=log10)
    ax2 = Axis(fig[1, 2], xlabel="Return period", ylabel="Return level", title="Pareto", xscale=log10)
    returnplot!(ax1, xs)
    returnplot!(ax2, ys)
    @test_reference joinpath(datadir, "return.png") fig
  end
end
