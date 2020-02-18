# This file was generated, do not modify it. # hide
kernel_smoother1 = ParticleMeshCoupling( domain, [nx], n_particles, 
                                         spline_degree-1, :galerkin)    

kernel_smoother0 = ParticleMeshCoupling( domain, [nx], n_particles, 
                                         spline_degree, :galerkin)