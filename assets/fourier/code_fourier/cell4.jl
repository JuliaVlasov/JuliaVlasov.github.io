# This file was generated, do not modify it. # hide
function compute_e(mesh::UniformMesh, ρ)

   n = mesh.length
   k =  2π / (mesh.stop - mesh.start)
   modes  = zeros(Float64, n)
   modes .= k * vcat(0:n÷2-1,-n÷2:-1)
   modes[1] = 1.0
   ρ̂ = fft(ρ)./modes
   vec(real(ifft(-1im .* ρ̂)))

end