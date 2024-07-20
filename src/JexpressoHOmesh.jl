"""
A research software for the numerical solution of a system of an arbitrary number of conservation laws using continuous spectral elements. DISCLAIMER: this is WIP and only 2D is being maintained until parallelization is complete.

If you are interested in contributing, please get in touch.
[Simone Marras](mailto:smarras@njit.edu), [Yassine Tissaoui](mailto:yt277@njit.edu)
"""
module Jexpresso

if Sys.isapple()
    using Metal
    using CUDA
elseif Sys.islinux()
    using CUDA
end

using KernelAbstractions
using Revise
using BenchmarkTools
using Dates
using DelimitedFiles
using SnoopCompile
using UnicodePlots
using Printf

TInt   = Int64
TFloat = Float64
cpu    = true

using DocStringExtensions

include(joinpath( "macros", "je_macros.jl"))

include(joinpath( "kernel", "abstractTypes.jl"))

include(joinpath( "kernel", "globalStructs.jl"))

include(joinpath( "kernel", "mesh", "mesh.jl"))

include(joinpath( "kernel", "bases", "basis_structs.jl"))

include(joinpath( "kernel", "mesh", "metric_terms.jl"))

include(joinpath( "kernel", "infrastructure", "element_matrices.jl"))

include(joinpath( "kernel", "infrastructure", "sem_setup.jl"))

include(joinpath( "kernel", "infrastructure", "convert_to_gpu.jl"))

include(joinpath( "io", "mod_inputs.jl"))

include(joinpath( "io", "write_output.jl"))

include(joinpath( "auxiliary", "checks.jl"))

include("./run.jl")

end
