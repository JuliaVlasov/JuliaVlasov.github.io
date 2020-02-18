# This file was generated, do not modify it. # hide
"""
    compute_rho(meshv, f)

Compute charge density
ρ(x,t) = ∫ f(x,v,t) dv
"""
function compute_rho(meshv::UniformMesh, 
        f::Array{Complex{Float64},2})
    
   dv = meshv.dx
   rho = dv * sum(real(f), dims=2)
   vec(rho .- mean(rho)) # vec squeezes the 2d array returned by sum function
end

"""
    compute_e(meshx, rho)
compute Ex using that -ik*Ex = rho 
"""
function compute_e(meshx::UniformMesh, rho::Vector{Float64})
   nx = meshx.nx
   k =  2π / (meshx.xmax - meshx.xmin)
   modes = zeros(Float64, nx)
   modes .= k * vcat(0:div(nx,2)-1,-div(nx,2):-1)
   modes[1] = 1.0
   rhok = fft(rho)./modes
   rhok .*= -1im
   ifft!(rhok)
   real(rhok)
end