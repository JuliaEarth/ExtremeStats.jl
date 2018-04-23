# ------------------------------------------------------------------
# Copyright (c) 2018, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    fit_mle(D, m)

Fit distribution `D` to maxima `m` with constrained maximum
likelihood estimation.
"""
function fit_mle(::Type{GeneralizedExtremeValue}, bm::BlockMaxima)
  # retrive maxima values
  x = collect(bm)
  n = length(x)

  # define optimization problem
  mle = Model(solver=IpoptSolver(print_level=0))
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

  status = JuMP.solve(mle)

  if status == :Optimal
    GeneralizedExtremeValue(getvalue(μ), getvalue(σ), getvalue(ξ))
  else
    error("could not fit distribution to maxima")
  end
end
