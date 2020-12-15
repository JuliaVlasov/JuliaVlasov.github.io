# This file was generated, do not modify it. # hide
nt = 1000
tf = 100.0
t  = range(0.0, stop=tf, length=nt)
@time nrj = landau_damping(tf, nt);

plot( t, nrj; label = "E")
plot!(t, -0.1533*t.-5.50; label="-0.1533t.-5.5")
savefig(joinpath(@OUTPUT, "landau1.svg")) # hide