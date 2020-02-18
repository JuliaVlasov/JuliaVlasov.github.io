# This file was generated, do not modify it. # hide
"""
    advection!(f, p, mesh, v, dt)

function to advect the distribution function `f` with velocity `v`
during a time step `dt`. Interpolation method uses bspline periodic.
"""
function advection!(f    :: Array{Complex{Float64},2}, 
                    p    :: Int64, 
                    mesh :: UniformMesh, 
                    v    :: Vector{Float64}, 
                    dt   :: Float64)
    
   nx = mesh.nx
   nv = length(v)
   dx = mesh.dx
   modes = [2π * i / nx for i in 0:nx-1]
    
   # compute eigenvalues of degree p b-spline matrix
   eig_bspl  = zeros(Float64, nx)
   eig_bspl .= bspline(p, -div(p+1,2), 0.0)
   for i in 1:div(p+1,2)-1
      eig_bspl .+= bspline(p, i - (p+1)÷2, 0.0) * 2 .* cos.(i * modes)
   end
   eigalpha = zeros(Complex{Float64}, nx)
    
   fft!(f,1)
    
   for j in 1:nv
      @inbounds alpha = dt * v[j] / dx
      # compute eigenvalues of cubic splines evaluated at displaced points
      ishift = floor(-alpha)
      beta   = -ishift - alpha
      fill!(eigalpha,0.0im)
      for i in -div(p-1,2):div(p+1,2)
         eigalpha .+= (bspline(p, i-div(p+1,2), beta) 
                        .* exp.((ishift+i) * 1im .* modes))
      end
          
      # compute interpolating spline using fft and properties of circulant matrices
      
      @inbounds f[:,j] .*= eigalpha ./ eig_bspl
        
   end
        
   ifft!(f,1)
    
end