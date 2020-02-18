# This file was generated, do not modify it. # hide
function landau( ϵ, kx, meshx, meshv)
    nx = meshx.nx
    nv = meshv.nx
    x  = meshx.x
    v  = meshv.x
    f  = zeros(Complex{Float64},(nx,nv))
    f .= (1.0.+ϵ*cos.(kx*x))/sqrt(2π) .* transpose(exp.(-0.5*v.^2))
    f
end

function advection_x!( f, p, meshx, v, dt) 
    advection!(f, p, meshx, v, dt)
end

function advection_v!( f, fᵗ, p, meshx, meshv, ℰ, dt)
     dx = meshx.dx
     nx = meshx.nx
     ρ  = compute_rho(meshv, f)
     e  = compute_e(meshx, ρ)
     push!(ℰ, 0.5*log(sum(e.*e)*dx))
     transpose!(fᵗ, f)
     advection!(fᵗ, p, meshv, e, dt)
     transpose!(f, fᵗ)
end

function landau_damping(tf::Float64, nt::Int64)
    
  # Set grid
  p = 3
  nx, nv = 128, 256
  xmin, xmax = 0.0, 4π
  vmin, vmax = -6., 6.
  meshx = UniformMesh(xmin, xmax, nx)
  meshv = UniformMesh(vmin, vmax, nv)
  x, v = meshx.x, meshv.x
    
  # Set distribution function for Landau damping
  ϵ, kx = 0.001, 0.5
  f = landau( ϵ, kx, meshx, meshv)
  
  fᵗ = zeros(Complex{Float64},(nv,nx))
  
  # Set time domain
  dt = tf / nt
  
  # Run simulation
  ℰ = Float64[]
  
  for it in 1:nt
        
     advection_x!( f, p, meshx, v, 0.5dt)
     advection_v!( f, fᵗ, p, meshx, meshv, ℰ, dt)
     advection_x!( f, p, meshx, v, 0.5dt)
        
  end
                  
  ℰ

end