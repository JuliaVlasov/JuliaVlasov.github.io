# This file was generated, do not modify it. # hide
sval = eval_uniform_periodic_spline_curve(spline_degree-1, efield_poisson)
plot( xg, sval, label="efield")       
savefig(joinpath(@OUTPUT, "gempic2.svg")) # hide