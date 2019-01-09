using OrdinaryDiffEq
f(u,p,t) = 5*u
u0=1/2
tspan = (0.0,1.0)
prob = ODEProblem(f,u0,tspan)
sol = solve(prob,ImplicitEuler(),reltol=1e-8,abstol=1e-8)
sol2 = solve(prob,ImplicitEuler(nlsolve=NLAnderson()),reltol=1e-8,abstol=1e-8)


println(sol(0.5))
println(sol2(0.5))
println(sol(0.6))
println(sol2(0.6))
println(sol(0.7))
println(sol2(0.7))
println(sol(0.8))
println(sol2(0.8))

#=
Output:
6.092146041064759
6.0921460410651695
10.044492387673492
10.04449238767406
16.560957606625994
16.560957606626918
27.305035704609843
27.30503570461198
=#