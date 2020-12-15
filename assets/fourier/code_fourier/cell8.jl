# This file was generated, do not modify it. # hide
"""
Landau damping initialisation function

[Wikipedia](https://en.wikipedia.org/wiki/Landau_damping)


"""
function landau( ϵ, kx, x, v )
    
    (1.0.+ϵ*cos.(kx*x))/sqrt(2π) .* transpose(exp.(-0.5*v.*v))
    
end


function vlasov_ampere( nx, nv, xmin, xmax, vmin, vmax , tf, nt)

    meshx = UniformMesh(xmin, xmax, nx)
    meshv = UniformMesh(vmin, vmax, nv)
            
    # Initialize distribution function
    x = meshx.points
    v = meshv.points
    ϵ, kx = 0.001, 0.5
    
    # Allocate arrays for distribution function and its transposed
    f = zeros(Complex{Float64},(nx,nv))
    fᵀ= zeros(Complex{Float64},(nv,nx))
    
    f .= landau( ϵ, kx, x, v)
    
    transpose!(fᵀ,f)
    
    ρ  = compute_rho(meshv, f)
    e  = zeros(ComplexF64, nx)
    e .= compute_e(meshx, ρ)
    
    nrj = Float64[]
    
    dt = tf / nt
    
    advection_x! = AmpereAdvection( meshx )
    advection_v! = AmpereAdvection( meshv )
            
    @showprogress 1 for i in 1:nt
        
        advection_v!(fᵀ, e,  0.5dt)
        
        transpose!(f,fᵀ)
        
        advection_x!( f, e, v, dt)
        
        push!(nrj, log(sqrt((sum(e.^2))*meshx.step)))
        
        transpose!(fᵀ,f)
        
        advection_v!(fᵀ, e,  0.5dt)
        
    end
    real(f), nrj
end