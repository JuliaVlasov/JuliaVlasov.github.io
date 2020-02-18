# This file was generated, do not modify it. # hide
function (adv :: AmpereAdvection)( fᵗ  :: Array{ComplexF64,2}, 
                                   e   :: Vector{ComplexF64}, 
                                   dt  :: Float64 )
    fft!(fᵗ, 1)
    fᵗ .= fᵗ .* exp.(-1im * dt * adv.kx * transpose(e))
    ifft!(fᵗ, 1)

end