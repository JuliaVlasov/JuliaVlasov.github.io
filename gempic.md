@def title = "GEMPIC"
@def hascode = true
@def date = Date(2020, 2, 18)
@def rss = "A short description of the page which would serve as **blurb** in a `RSS` feed; you can use basic markdown here but the whole description string must be a single line (not a multiline string). Like this one for instance. Keep in mind that styling is minimal in RSS so for instance don't expect maths or fancy styling to work; images should be ok though: ![](https://upload.wikimedia.org/wikipedia/en/3/32/Rick_and_Morty_opening_credits.jpeg)"

# GEMPIC

[Geometric ElectroMagnetic Particle-In-Cell Methods](https://arxiv.org/abs/1609.03053)

*Michael Kraus, Katharina Kormann, Philip J. Morrison, Eric Sonnendrücker*

Framework for Finite Element Particle-in-Cell methods based on 
the discretization of the underlying Hamiltonian structure of the 
Vlasov-Maxwell system. 

## Install the GEMPIC package

```julia
using ProgressMeter, Plots, GEMPIC
```

## Strong Landau Damping

### The physical parameters 

```julia
kx, α = 0.5, 0.5
xmin, xmax = 0, 2π/kx
domain = [xmin, xmax, xmax - xmin]
```

### The numerical parameters

```julia
∆t = 0.05
nx = 32 
n_particles = 100000
mesh = GEMPIC.Mesh( xmin, xmax, nx)
spline_degree = 3
```

### Initialize particles

```julia
mass, charge = 1.0, 1.0
particle_group = GEMPIC.ParticleGroup{1,2}( n_particles, mass, charge, 1)   
sampler = LandauDamping( α, kx)

sample!(sampler, particle_group)
```

### Particle-mesh coupling operators

```julia
kernel_smoother1 = ParticleMeshCoupling( domain, [nx], n_particles, 
                                         spline_degree-1, :galerkin)    

kernel_smoother0 = ParticleMeshCoupling( domain, [nx], n_particles, 
                                         spline_degree, :galerkin)
```

### Allocate electrostatic fields and Maxwell solver

```julia
rho = zeros(Float64, nx)
efield_poisson = zeros(Float64, nx)

maxwell_solver = Maxwell1DFEM(domain, nx, spline_degree)

solve_poisson!( efield_poisson, particle_group, 
                kernel_smoother0, maxwell_solver, rho)
```

### Charge density

```julia
xg = LinRange(xmin, xmax, nx)
sval = eval_uniform_periodic_spline_curve(spline_degree-1, rho)
plot( xg, sval, label="ρ")
```

### Electric field 

```julia
sval = eval_uniform_periodic_spline_curve(spline_degree-1, efield_poisson)
plot( xg, sval, label="efield")       
```

### Initialize the arrays for the spline coefficients of the fields

```julia
efield_dofs = [copy(efield_poisson), zeros(Float64, nx)]
bfield_dofs = zeros(Float64, nx)
    
propagator = HamiltonianSplitting( maxwell_solver,
                                   kernel_smoother0, 
                                   kernel_smoother1, 
                                   particle_group,
                                   efield_dofs,
                                   bfield_dofs,
                                   domain);

efield_dofs_n = propagator.e_dofs

thdiag = TimeHistoryDiagnostics( particle_group, maxwell_solver, 
                        kernel_smoother0, kernel_smoother1 );
```

### Loop over time

```julia
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
```

### Diagnostics stored in a dataframe

```julia
using DataFrames
first(thdiag.data, 5)

plot(thdiag.data[!,:Time], log.(thdiag.data[!,:PotentialEnergyE1]))
```
