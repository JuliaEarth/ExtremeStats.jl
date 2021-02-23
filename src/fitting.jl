# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------


"""
  log_gpd_pdf(arg, μ, σ, ξ)

Log density function of the generalized Pareto distribution, 
with an expansion with ξ near zero.
"""
function log_gpd_pdf(_x, μ, σ, ξ)
  x = (_x-μ)/σ
  expn = if abs(ξ) < 1e-4
    # expansion for ξ near zero.
    -x*(ξ+1) + (x^2)*ξ*(ξ+1)/2 - (x^3)*(ξ^2)*(ξ+1)/3 + (x^4)*(ξ^3)*(ξ+1)/4
  else
    (-(ξ+1)/ξ)*log(max(0, 1 + x*ξ))
  end
  expn - log(σ)
end


"""
  log_gev_pdf(arg, μ, σ, ξ)

Log density function of the generalized extreme value distribution, 
with an expansion with ξ near zero.
"""
function log_gev_pdf(_x, μ, σ, ξ)
  x = (_x-μ)/σ
  tx = if abs(ξ) < 1e-4
    # expansion near zero.
    -x + (x^2)*ξ/2 - (x^3)*(ξ^2)/3 + (x^4)*(ξ^3)/4
  else
    (-1/ξ)*log(max(0, 1 + x*ξ))
  end
  (ξ+1)*tx - exp(tx) - log(σ)
end


"""
    fit_mle(gev, bm)

Fit generalized extreme value distribution `gev` to block maxima
`bm` with constrained maximum likelihood estimation.
"""
function fit_mle(::Type{GeneralizedExtremeValue}, bm::BlockMaxima)
  # retrieve maxima values
  x = collect(bm)
  n = length(x)

  # set up the problem
  mle = Model(with_optimizer(Ipopt.Optimizer, print_level=0, sb="yes"))
  @variable(mle, μ, start=0.0)
  @variable(mle, σ, start=1.0)
  @variable(mle, ξ, start=0.1)
  JuMP.register(mle, :log_gev_pdf, 4, log_gev_pdf, autodiff=true)
  @NLobjective(mle, Max, sum(log_gev_pdf(z, μ, σ, ξ) for z in x))
  @NLconstraint(mle, [i=1:n], 1 + ξ*(x[i]-μ)/σ ≥ 1e-6)
  @constraint(mle, σ ≥ 1e-6)
  @constraint(mle, ξ ≥ -1/2)

  # attempt to solve
  optimize!(mle)

  # retrieve solver status
  status = termination_status(mle)

  # acceptable statuses
  OK = (MOI.OPTIMAL, MOI.LOCALLY_SOLVED)

  if status ∈ OK
    GeneralizedExtremeValue(value(μ), value(σ), value(ξ))
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

  # set up the problem
  mle = Model(with_optimizer(Ipopt.Optimizer, print_level=0, sb="yes"))
  @variable(mle, σ, start=1.0)
  @variable(mle, ξ, start=0.1)
  JuMP.register(mle, :log_gpd_pdf, 4, log_gpd_pdf, autodiff=true)
  @NLobjective(mle, Max, sum(log_gpd_pdf(z, 0, σ, ξ) for z in y))
  @NLconstraint(mle, [i=1:n], 1 + ξ*y[i]/σ ≥ 1e-6)
  @constraint(mle, σ ≥ 1e-6)
  @constraint(mle, ξ ≥ -1/2)

  # attempt to solve both cases
  optimize!(mle)

  # retrieve solver status
  status  = termination_status(mle)

  # acceptable statuses
  OK = (MOI.OPTIMAL, MOI.LOCALLY_SOLVED)

  if status ∈ OK
    GeneralizedPareto(pm.u, value(σ), value(ξ))
  else
    error("could not fit distribution to maxima")
  end
end
