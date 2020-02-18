# This file was generated, do not modify it. # hide
rho = zeros(Float64, nx)
efield_poisson = zeros(Float64, nx)

maxwell_solver = Maxwell1DFEM(domain, nx, spline_degree)

solve_poisson!( efield_poisson, particle_group, 
                kernel_smoother0, maxwell_solver, rho)