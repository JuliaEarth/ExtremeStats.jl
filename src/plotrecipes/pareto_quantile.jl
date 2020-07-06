# ------------------------------------------------------------------
# Copyright (c) 2018, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

@userplot ParetoPlot

@recipe function f(p::ParetoPlot)
  # get user input
  data = p.args[1]

  x = sort(data, rev=true)
  n = length(x)
  logp = log.([i/(n+1) for i in 1:n])
  logx = log.(x)

  seriestype --> :scatter
  xguide --> "-log(i/(n+1))"
  yguide --> "log(x*)"

  -logp, logx
end
