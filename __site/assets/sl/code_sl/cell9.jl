# This file was generated, do not modify it. # hide
"""

    @Strang( push_t, push_v )

    Apply the second order Strang splitting

    push_t and push_v are two function calls with
    `dt` as argument.

"""
macro Strang(push_t, push_v)
    return esc(quote
        local full_dt = dt
        dt = 0.5full_dt
        $push_t
        dt = full_dt
        $push_v
        dt = 0.5full_dt
        $push_t
        dt = full_dt
    end)
end

function landau_with_macro(tf::Float64, nt::Int64)
    
  # Set grid
  p = 3
  nx, nv = 128, 256
  xmin, xmax = 0.0, 4π
  vmin, vmax = -6., 6.
  meshx = UniformMesh(xmin, xmax, nx)
  meshv = UniformMesh(vmin, vmax, nv)
  x, v = meshx.x, meshv.x    
  dx = meshx.dx
  
  # Set distribution function for Landau damping
  ϵ, kx = 0.001, 0.5
  f  = landau( ϵ, kx, meshx, meshv)
  fᵗ = zeros(Complex{Float64},(nv,nx))
    
  # Instantiate distribution functions
  advection_x! = Advection(p, meshx)
  advection_v! = Advection(p, meshv)
    
  push_t!( f, v, dt ) = advection_x!(f, v, dt)

  function push_v!( f, fᵗ, meshx, meshv, dt, ℰ)
    
      ρ = compute_rho(meshv, f)
      e = compute_e(meshx, ρ)
     
      push!(ℰ, 0.5*log(sum(e.*e)*dx))
     
      transpose!(fᵗ, f)
      advection_v!(fᵗ, e, dt)
      transpose!(f, fᵗ)
    
  end
  
  # Set time step
  dt = tf / nt
  
  # Run simulation
  ℰ = Float64[]
  
  for it in 1:nt
        
       @Strang( push_t!( f, v, dt ),
                push_v!( f, fᵗ, meshx, meshv, dt, ℰ))
        
  end
                  
  ℰ

end

nt = 1000
tf = 100.0
t  = range(0.0, stop=tf, length=nt)
@time nrj = landau_with_macro(tf, nt);
plot( t, nrj; label = "E")
plot!(t, -0.1533*t.-5.50; label="-0.1533t.-5.5")
savefig(joinpath(@OUTPUT, "landau3.svg")) # hide