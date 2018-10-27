## Welcome 

If you are interested to code in Julia the numerical solution of Vlasov equation, you can join us. Only one
rule, make a package.

- VlasovBase is a package containing geometry and mesh types and some simple fields solvers.
- SemiLagrangian contains fast interpolation to solve the equation using the semi-lagrange approach.
- Fourier will contain some implementations of advection where derivatives are computed in Fourier space.
- VlasovExample is the package for test cases: Landau damping, Bump on tail, Two streams instability...
- HermiteGF is a stable implementation of Hermite interpolation.
- SplittingOperators is a package containing macros to facilitate use of splittings techniques.
