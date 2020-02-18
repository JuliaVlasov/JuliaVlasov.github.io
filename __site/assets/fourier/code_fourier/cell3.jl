# This file was generated, do not modify it. # hide
function compute_rho(meshv::UniformMesh, f)

   dv  = meshv.step
   ρ = dv .* vec(sum(real(f), dims=2))
   ρ .- mean(ρ)
   
end