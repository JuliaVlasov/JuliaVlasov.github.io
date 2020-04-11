## Solving the Vlasov equation with Julia

The [Vlasov equation](https://en.wikipedia.org/wiki/Vlasov_equation)
is of fundamental importance in plasma physics and particularly
for simulations in Magnetic fusion and of Tokamak plasmas.  I try
to use the [Julia language](https://julialang.org) to solve it numerically.

First examples solve the kinetic simulation
of Vlasov-Poisson system by [the semi-lagrangian method](https://hal.univ-lorraine.fr/hal-01791851).
Some packages uses the [Particle In Cell](https://arxiv.org/abs/1609.03053) method to solve the problem.

We are basing much of this effort on [a previous implementation in the Fortran language](http://selalib.gforge.inria.fr).
We have found that the translation into Julia is easy and it is interesting to look at what
it has to offer without degrading performance.

- [VlasovBase](https://github.com/JuliaVlasov/VlasovBase.jl) is a package containing geometry and mesh types and some simple fields solvers.
- [SemiLagrangian](https://github.com/JuliaVlasov/SemiLagrangian.jl)  contains fast interpolation to solve the equation using the semi-lagrange approach.
- [FourierAdvections](https://github.com/JuliaVlasov/FourierAdvections.jl) contains implementations of advection where derivatives are computed in Fourier space.
- [HermiteGF](https://github.com/JuliaVlasov/HermiteGF.jl)  is a stable implementation of Hermite interpolation.
- [SplittingOperators](https://github.com/JuliaVlasov/SplittingOperators.jl)  is a package containing macros to facilitate use of splittings techniques.
