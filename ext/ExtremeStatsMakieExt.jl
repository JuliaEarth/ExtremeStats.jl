# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

module ExtremeStatsMakieExt

using ExtremeStats

import ExtremeStats: excessplot, excessplot!
import ExtremeStats: paretoplot, paretoplot!
import ExtremeStats: returnplot, returnplot!

import Makie

# ------------
# EXCESS PLOT
# ------------

Makie.@recipe ExcessPlot (xs,) begin
  color = :slategray
  alpha = 1.0
  linestyle = :solid
  linewidth = 2
end

function Makie.plot!(plot::ExcessPlot)
  # retrieve values and plot attributes
  xs = plot.xs
  color = plot.color
  alpha = plot.alpha
  linestyle = plot.linestyle
  linewidth = plot.linewidth

  # compute mean excesses
  ks = Makie.@lift 2:length($xs)
  ξs = Makie.@lift meanexcess($xs, $ks)

  # plot as lines
  Makie.lines!(plot, ks, ξs; color, alpha, linestyle, linewidth)
end

# ------------
# PARETO PLOT
# ------------

Makie.@recipe ParetoPlot (xs,) begin
  color = :slategray
  alpha = 1.0
  marker = :circle
  markersize = 4
end

function Makie.plot!(plot::ParetoPlot)
  # retrieve values and plot attributes
  xs = plot.xs
  color = plot.color
  alpha = plot.alpha
  marker = plot.marker
  markersize = plot.markersize

  # sort values and compute length
  y = Makie.@lift sort($xs, rev=true)
  n = Makie.@lift length($y)

  # compute log-probabilities and log-values
  logp = Makie.@lift map(i -> -log(i / ($n + 1)), 1:$n)
  logy = Makie.@lift map(log, $y)

  # plot as scatter
  Makie.scatter!(plot, logp, logy; color, alpha, marker, markersize)
end

# ------------
# RETURN PLOT
# ------------

Makie.@recipe ReturnPlot (xs,) begin
  color = :slategray
  alpha = 1.0
  marker = :circle
  markersize = 4
end

function Makie.plot!(plot::ReturnPlot)
  # retrieve values and plot attributes
  xs = plot.xs
  color = plot.color
  alpha = plot.alpha
  marker = plot.marker
  markersize = plot.markersize

  # compute return levels
  res = Makie.@lift returnlevels($xs)

  # extract periods and levels
  dt = Makie.@lift $res[1]
  ms = Makie.@lift $res[2]

  # plot as scatter
  Makie.scatter!(plot, dt, ms; color, alpha, marker, markersize)
end

end
