# This file was generated, do not modify it. # hide
function (adv :: AmpereAdvection)( f   :: Array{ComplexF64,2}, 
                                   e   :: Vector{ComplexF64}, 
                                   v   :: Vector{Float64}, 
                                   dt  :: Float64 )
    
    ev = exp.(-1im*dt * adv.kx * transpose(v))    
    
    fft!(f,1)
    f .= f .* ev
    dv = v[2]-v[1]
    ρ = dv * vec(sum(f,dims=2))  
    for i in 2:length(e)
        e[i] = -1im * ρ[i] ./ adv.kx[i]
    end
    e[1] = 0.0
    ifft!(f,1)
    ifft!(e)
    e .= real(e)
end