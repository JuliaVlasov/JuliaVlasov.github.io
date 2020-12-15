# This file was generated, do not modify it. # hide
struct AmpereAdvection 
    
    mesh :: UniformMesh
    kx   :: Vector{Float64}

    function AmpereAdvection( mesh )
        
        nx  = mesh.length
        dx  = mesh.step
        Lx  = mesh.stop - mesh.start
        kx  = zeros(Float64, nx)
        kx .= 2π/Lx .* [0:nx÷2-1;-nx÷2:-1]
        new( mesh, kx)
      
    end

end