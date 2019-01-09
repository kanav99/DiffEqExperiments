using OrdinaryDiffEq, BenchmarkTools
f(u,p,t) = 5*u
u0=1/2
tspan = (0.0,1.0)
prob = ODEProblem(f,u0,tspan)
@benchmark solve(prob,ImplicitEuler(nlsolve=NLNewton()),reltol=1e-8,abstol=1e-8)
@benchmark solve(prob,ImplicitEuler(nlsolve=NLFunctional()),reltol=1e-8,abstol=1e-8)
@benchmark solve(prob,ImplicitEuler(nlsolve=NLAnderson()),reltol=1e-8,abstol=1e-8)

#=
Output:
BenchmarkTools.Trial: 
  memory estimate:  11.13 MiB
  allocs estimate:  70376
  --------------
  minimum time:     46.389 ms (0.00% GC)
  median time:      51.395 ms (0.00% GC)
  mean time:        54.113 ms (7.71% GC)
  maximum time:     147.471 ms (59.00% GC)
  --------------
  samples:          93
  evals/sample:     1

BenchmarkTools.Trial: 
  memory estimate:  11.13 MiB
  allocs estimate:  70367
  --------------
  minimum time:     46.460 ms (0.00% GC)
  median time:      50.618 ms (0.00% GC)
  mean time:        52.479 ms (8.00% GC)
  maximum time:     132.276 ms (61.87% GC)
  --------------
  samples:          96
  evals/sample:     1

BenchmarkTools.Trial: 
  memory estimate:  123.16 MiB
  allocs estimate:  1328971
  --------------
  minimum time:     131.369 ms (25.60% GC)
  median time:      152.998 ms (29.47% GC)
  mean time:        186.194 ms (38.59% GC)
  maximum time:     313.222 ms (51.45% GC)
  --------------
  samples:          27
  evals/sample:     1

=#