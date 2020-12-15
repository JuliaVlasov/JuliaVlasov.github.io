# This file was generated, do not modify it. # hide
xg = LinRange(xmin, xmax, nx)
sval = eval_uniform_periodic_spline_curve(spline_degree-1, rho)
plot( xg, sval, label="rho")
savefig(joinpath(@OUTPUT, "gempic1.svg")) # hide