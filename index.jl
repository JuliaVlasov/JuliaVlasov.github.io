using MultiDocumenter

clonedir = mktempdir()

docs = [
    MultiDocumenter.MultiDocRef(
        upstream = joinpath(clonedir, "GEMPIC"),
        path = "gempic",
        name = "GEMPIC",
        giturl = "https://github.com/JuliaVlasov/GEMPIC.jl.git",
    ),
    MultiDocumenter.MultiDocRef(
        upstream = joinpath(clonedir, "SemiLagrangian"),
        path = "semilagrangian",
        name = "SemiLagrangian",
        giturl = "https://github.com/JuliaVlasov/SemiLagrangian.jl.git",
    ),
    MultiDocumenter.MultiDocRef(
        upstream = joinpath(clonedir, "VlasovSolvers"),
        path = "vlasovsolvers",
        name = "VlasovSolvers",
        giturl = "https://github.com/JuliaVlasov/VlasovSolvers.jl.git",
    ),
    MultiDocumenter.MultiDocRef(
        upstream = joinpath(clonedir, "SpinGEMPIC"),
        path = "scalarspin",
        name = "SpinGEMPIC",
        giturl = "https://github.com/JuliaVlasov/SpinGEMPIC.jl.git",
    ),
    MultiDocumenter.MultiDocRef(
        upstream = joinpath(clonedir, "VectorSpin"),
        path = "vectorspin",
        name = "VectorSpin",
        giturl = "https://github.com/JuliaVlasov/VectorSpin.jl.git",
    ),
]

outpath = joinpath(@__DIR__, "out")

MultiDocumenter.make(
    outpath,
    docs;
    search_engine = MultiDocumenter.SearchConfig(
        index_versions = ["dev"],
        engine = MultiDocumenter.FlexSearch
    )
)
