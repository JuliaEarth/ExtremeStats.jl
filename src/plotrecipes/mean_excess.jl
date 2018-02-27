# ------------------------------------------------------------------
# Copyright (c) 2018, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

@userplot ExcessPlot

@recipe function f(p::ExcessPlot)
  # get user input
  data = p.args[1]

  x = sort(data, rev=true)
  ks = 2:length(x)
  ξs = [mean(log.(x[1:k-1]) - log(x[k])) for k in ks]

  seriestype --> :path
  xlabel --> "number of maxima"
  ylabel --> "extreme value index"
  legend --> false

  ks, ξs
end
