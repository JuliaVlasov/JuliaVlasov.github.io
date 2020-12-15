# This file was generated, do not modify it. # hide
mass, charge = 1.0, 1.0
particle_group = GEMPIC.ParticleGroup{1,2}( n_particles, mass, charge, 1)   
sampler = LandauDamping( α, kx)

sample!(sampler, particle_group)