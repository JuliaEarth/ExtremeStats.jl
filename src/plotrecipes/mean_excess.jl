# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

@userplot ExcessPlot

@recipe function f(p::ExcessPlot)
  # get user input
  xs = p.args[1]

  ks = 2:length(xs)
  ξs = meanexcess(xs, ks)

  seriestype --> :path
  xguide --> "number of maxima"
  yguide --> "extreme value index"

  ks, ξs
end
