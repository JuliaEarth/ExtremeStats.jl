# ------------------------------------------------------------------
# Copyright (c) 2018, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    fit_mle(gev, bm)

Fit generalized extreme value distribution `gev` to block maxima
`bm` with constrained maximum likelihood estimation.
"""
function fit_mle(::Type{GeneralizedExtremeValue}, bm::BlockMaxima)
  # retrieve maxima values
  x = collect(bm)
  n = length(x)

  # MLE for case ξ ≠ 0
  mle = Model(with_optimizer(Ipopt.Optimizer, print_level=0, sb="yes"))
  @variable(mle, μ, start=0.0)
  @variable(mle, σ, start=1.0)
  @variable(mle, ξ, start=0.1)
  @NLobjective(mle, Max,
    -n*log(σ)
    -(1 + 1/ξ)*sum(log(1 + ξ*(x[i]-μ)/σ) for i in 1:n)
    -sum((1 + ξ*(x[i]-μ)/σ)^(-1/ξ) for i in 1:n)
  )
  @NLconstraint(mle, [i=1:n], 1 + ξ*(x[i]-μ)/σ ≥ 1e-6)
  @NLconstraint(mle, abs(ξ) ≥ 1e-6)
  @constraint(mle, σ ≥ 1e-6)

  # MLE for case ξ = 0
  mle₀ = Model(with_optimizer(Ipopt.Optimizer, print_level=0, sb="yes"))
  @variable(mle₀, μ₀, start=0.0)
  @variable(mle₀, σ₀, start=1.0)
  @NLobjective(mle₀, Max,
    -n*log(σ₀)
    -sum((x[i]-μ₀)/σ₀ for i in 1:n)
    -sum(exp(-(x[i]-μ₀)/σ₀) for i in 1:n)
  )
  @constraint(mle₀, σ₀ ≥ 1e-6)

  # attempt to solve both cases
  optimize!(mle)
  optimize!(mle₀)

  # retrieve solver status
  status  = termination_status(mle)
  status₀ = termination_status(mle₀)

  # acceptable statuses
  OK = MOI.OPTIMAL

  if status == OK && status₀ == OK
    # choose the maximum amongst the two
    if objective_value(mle) > objective_value(mle₀)
      GeneralizedExtremeValue(value(μ), value(σ), value(ξ))
    else
      GeneralizedExtremeValue(value(μ₀), value(σ₀), 0.)
    end
  elseif status == OK
    GeneralizedExtremeValue(value(μ), value(σ), value(ξ))
  elseif status₀ == OK
    GeneralizedExtremeValue(value(μ₀), value(σ₀), 0.)
  else
    error("could not fit distribution to maxima")
  end
end

"""
    fit_mle(gp, pm)

Fit generalized Pareto distribution `gp` to peak over threshold
maxima `pm` with constrained maximum likelihood estimation.
"""
function fit_mle(::Type{GeneralizedPareto}, pm::PeakOverThreshold)
  # retrieve maxima values
  x = collect(pm)
  n = length(x)

  # compute excess
  y = x .- pm.u

  # MLE for case ξ ≠ 0
  mle = Model(with_optimizer(Ipopt.Optimizer, print_level=0, sb="yes"))
  @variable(mle, σ, start=1.0)
  @variable(mle, ξ, start=0.1)
  @NLobjective(mle, Max,
    -n*log(σ)
    -(1 + 1/ξ)*sum(log(1 + ξ*y[i]/σ) for i in 1:n)
  )
  @NLconstraint(mle, [i=1:n], 1 + ξ*y[i]/σ ≥ 1e-6)
  @NLconstraint(mle, abs(ξ) ≥ 1e-6)
  @constraint(mle, σ ≥ 1e-6)

  # MLE for case ξ = 0
  mle₀ = Model(with_optimizer(Ipopt.Optimizer, print_level=0, sb="yes"))
  @variable(mle₀, σ₀, start=1.0)
  @NLobjective(mle₀, Max,
    -n*log(σ₀)
    -sum(y[i] for i in 1:n)/σ₀
  )
  @constraint(mle₀, σ₀ ≥ 1e-6)

  # attempt to solve both cases
  optimize!(mle)
  optimize!(mle₀)

  # retrieve solver status
  status  = termination_status(mle)
  status₀ = termination_status(mle₀)

  # acceptable statuses
  OK = MOI.LOCALLY_SOLVED

  if status == OK && status₀ == OK
    # choose the maximum amongst the two
    if objective_value(mle) > objective_value(mle₀)
      GeneralizedPareto(0.0, value(σ), value(ξ))
    else
      GeneralizedPareto(0.0, value(σ₀), 0.0)
    end
  elseif status == OK
    GeneralizedPareto(0.0, value(σ), value(ξ))
  elseif status₀ == OK
    GeneralizedPareto(0.0, value(σ₀), 0.0)
  else
    error("could not fit distribution to maxima")
  end
end
