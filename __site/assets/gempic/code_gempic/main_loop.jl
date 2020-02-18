# This file was generated, do not modify it. # hide
steps, Δt = 500, 0.05

@showprogress 1 for j = 1:steps # loop over time

    ## Strang splitting
    strang_splitting!(propagator, Δt, 1)

    ## Diagnostics
    solve_poisson!( efield_poisson, particle_group, 
                    kernel_smoother0, maxwell_solver, rho)
    
    write_step!(thdiag, j * Δt, spline_degree, 
                    efield_dofs,  bfield_dofs,
                    efield_dofs_n, efield_poisson)

end