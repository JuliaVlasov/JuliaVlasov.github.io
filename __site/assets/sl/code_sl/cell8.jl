# This file was generated, do not modify it. # hide
"""
    Advection(f, p, mesh, v, nv, dt)

Advection type

"""
mutable struct Advection
    
    p        :: Int64 
    mesh     :: UniformMesh
    modes    :: Vector{Float64}
    eig_bspl :: Vector{Float64}
    eigalpha :: Vector{Complex{Float64}}
    
    function Advection( p, mesh )
        nx        = mesh.nx
        modes     = zeros(Float64, nx)
        modes    .= [2π * i / nx for i in 0:nx-1]
        eig_bspl  = zeros(Float64, nx)
        eig_bspl  = zeros(Float64, nx)
        eig_bspl .= bspline(p, -div(p+1,2), 0.0)
        for i in 1:div(p+1,2)-1
            eig_bspl .+= bspline(p, i-(p+1)÷2, 0.0) * 2 .* cos.(i * modes)
        end
        eigalpha  = zeros(Complex{Float64}, nx)
        new( p, mesh, modes, eig_bspl, eigalpha )
    end
    
end

function (adv :: Advection)(f    :: Array{Complex{Float64},2}, 
                            v    :: Vector{Float64}, 
                            dt   :: Float64)
    
   nx = adv.mesh.nx
   nv = length(v)
   dx = adv.mesh.dx
    
   fft!(f,1)
    
   for j in 1:nv
      @inbounds alpha = dt * v[j] / dx
      # compute eigenvalues of cubic splines evaluated at displaced points
      ishift = floor(-alpha)
      beta   = -ishift - alpha
      fill!(adv.eigalpha,0.0im)
      for i in -div(adv.p-1,2):div(adv.p+1,2)
         adv.eigalpha .+= (bspline(adv.p, i-div(adv.p+1,2), beta) 
                        .* exp.((ishift+i) * 1im .* adv.modes))
      end
          
      # compute interpolating spline using fft and properties of circulant matrices
      
      @inbounds f[:,j] .*= adv.eigalpha ./ adv.eig_bspl
        
   end
        
   ifft!(f,1)
    
end            

function landau_damping_hl(tf::Float64, nt::Int64)
    
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
  f = landau( ϵ, kx, meshx, meshv)
  fᵗ = zeros(Complex{Float64},(nv,nx))
    
  # Instantiate advection functions
  advection_x! = Advection(p, meshx)
  advection_v! = Advection(p, meshv)
  
  # Set time step
  dt = tf / nt
  
  # Run simulation
  ℰ = Float64[]
  
  for it in 1:nt
        
       advection_x!(f, v, 0.5dt)

       ρ = compute_rho(meshv, f)
       e = compute_e(meshx, ρ)
        
       push!(ℰ, 0.5*log(sum(e.*e)*dx))
        
       transpose!(fᵗ, f)
       advection_v!(fᵗ, e, dt)
       transpose!(f, fᵗ)
    
       advection_x!(f, v, 0.5dt)
        
  end
                  
  ℰ

end

nt = 1000
tf = 100.0
t  = range(0.0, stop=tf, length=nt)
@time nrj = landau_damping_hl(tf, nt);

plot( t, nrj; label = "E")
plot!(t, -0.1533*t.-5.50; label="-0.1533t.-5.5")
savefig(joinpath(@OUTPUT, "landau2.svg")) # hide