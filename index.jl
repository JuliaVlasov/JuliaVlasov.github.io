using MultiDocumenter

clonedir = mktempdir()

docs = [
    ("JuliaVlasov/GEMPIC.jl.git", "gh-pages") => MultiDocumenter.MultiDocRef(
        upstream = joinpath(clonedir, "GEMPIC"),
        path = "gempic",
        name = "GEMPIC"
    ),
    ("JuliaVlasov/SemiLagrangian.jl.git", "gh-pages") => MultiDocumenter.MultiDocRef(
        upstream = joinpath(clonedir, "SemiLagrangian"),
        path = "semi-lagrangian",
        name = "SemiLagrangian"
    ),
    ("JuliaVlasov/VlasovSolvers.jl.git", "gh-pages") => MultiDocumenter.MultiDocRef(
        upstream = joinpath(clonedir, "VlasovSolvers"),
        path = "vlasov-solvers",
        name = "VlasovSolvers"
    ),
    ("JuliaVlasov/SpinGEMPIC.jl.git", "gh-pages") => MultiDocumenter.MultiDocRef(
        upstream = joinpath(clonedir, "SpinGEMPIC"),
        path = "scalar-spin",
        name = "SpinGEMPIC"
    ),
    ("JuliaVlasov/VectorSpinVlasovMaxwell1D1V.jl.git", "gh-pages") => MultiDocumenter.MultiDocRef(
        upstream = joinpath(clonedir, "VectorSpin"),
        path = "vector-spin",
        name = "VectorSpin"
    ),
]

for ((remote, branch), docref) in docs
    run(`git clone --depth 1 git@github.com:$remote --branch $branch --single-branch $(docref.upstream)`)
end

outpath = joinpath(@__DIR__, "out")

MultiDocumenter.make(
    outpath,
    collect(last.(docs));
    search_engine = MultiDocumenter.SearchConfig(
        index_versions = ["dev"],
        engine = MultiDocumenter.FlexSearch
    )
)
