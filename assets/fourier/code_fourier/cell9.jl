# This file was generated, do not modify it. # hide
nx, nv = 256, 256
xmin, xmax =  0., 4*π
vmin, vmax = -6., 6.
tf = 60
nt = 600
t =  range(0,stop=tf,length=nt)
plot(t, -0.1533*t.-5.48)
f, nrj = vlasov_ampere(nx, nv, xmin, xmax, vmin, vmax, tf, nt)
plot!(t, nrj , label=:ampere )
plot!(size=(900,600)) # hide
savefig(joinpath(@OUTPUT, "ampere.svg")) # hide