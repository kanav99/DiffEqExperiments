using ForwardDiff
using BenchmarkTools

mutable struct SuperDAEJacobianWrapper{F,pType,duType,uType,gammaType,tmpType,uprevType,tType}
	f::F
	p::pType
	tmp_du::duType
	tmp_u::uType
	γ::gammaType
	tmp::tmpType
	uprev::uprevType
	t::tType
	function SuperDAEJacobianWrapper(f,p,du,u,γ,tmp,uprev,t)
		X = eltype(u)
		N = ForwardDiff.chunksize(ForwardDiff.Chunk(u))
		tmp_du = similar(u, ForwardDiff.Dual{Nothing,X,N})
		tmp_u  = similar(u, ForwardDiff.Dual{Nothing,X,N})
		new{typeof(f),typeof(p),typeof(tmp_du),typeof(tmp_u),typeof(γ),typeof(tmp),typeof(uprev),typeof(t)}(f,p,tmp_du,tmp_u,γ,tmp,uprev,t)
	end
end

function (m::SuperDAEJacobianWrapper)(out,x)
	@. m.tmp_du = m.γ * x + m.tmp
	@. m.tmp_u = x + m.uprev
	m.f(out, m.tmp_du, m.tmp_u, m.p, m.t)
end


f(out,du,u,p,t) = @. out = du - u

# problem specification
u0 = ones(5)
du0 = ones(5)
tspan = (0.0,1.0)

# inside the DiffEq ecosystem, we are at the very first step with dt = 0.1
dt = 0.1
γ = 10.0 # i.e. inv(dt)
uprev = zeros(5)
tmp = similar(u0)
tprev = 0.0
t = 0.1
out = zeros(5)
J = false .* vec(uprev) .* vec(uprev)'

super = SuperDAEJacobianWrapper(f,nothing,du0,u0,γ,tmp,uprev,t)

cfg = ForwardDiff.JacobianConfig(nothing, out, uprev)
@btime ForwardDiff.jacobian!(J,super,out,uprev,cfg)
@show J
