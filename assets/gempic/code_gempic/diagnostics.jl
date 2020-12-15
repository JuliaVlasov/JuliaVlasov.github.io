# This file was generated, do not modify it. # hide
using DataFrames
first(thdiag.data, 5)

plot(thdiag.data[!,:Time], log.(thdiag.data[!,:PotentialEnergyE1]))
savefig(joinpath(@OUTPUT, "gempic3.svg")) # hide