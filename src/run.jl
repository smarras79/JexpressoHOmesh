using ArgParse
#--------------------------------------------------------
# The problem name is a command line argument:
#
# 1. Launch Julia:
# >> julia --project=.
#
# 2. Push equations name to ARGS
#    You need this only when you run a new equations
#
#    julia > push!(empty!(ARGS), PROBLEM_CASE_NAME::String);
#    julia > include(./src/JexpressoHOmesh.jl)
##
# Ex. To run the Compressible Euler equations in $JEXPRESSO/src/problems/
# 
#  julia > push!(empty!(ARGS), "grid");
#  julia > include(./src/JexpressoHOmesh.jl)
#
#--------------------------------------------------------
function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table s begin
        
        "problem"
        help = "problem directory name"
        default = "grid"
        required = false
        
    end

    return parse_args(s)
end

#--------------------------------------------------------
# Parse command line args:
#--------------------------------------------------------
parsed_args      = parse_commandline()
parsed_case_name = string(parsed_args["problem"])
driver_file      = string(dirname(@__DIR__()), "/problems/drivers.jl")

# Check if running under CI environment and set directory accordingly
case_name_dir = string(dirname(@__DIR__()), "/problems/", parsed_case_name)

user_input_file = string(case_name_dir, "/user_inputs.jl")

include(driver_file)
include(user_input_file)

#--------------------------------------------------------
# Read User Inputs:
#--------------------------------------------------------
mod_inputs_print_welcome()
inputs = Dict{}()

inputs = user_inputs()
mod_inputs_user_inputs!(inputs)

#--------------------------------------------------------
# Create output directory if it doesn't exist:
#--------------------------------------------------------
user_defined_output_dir = inputs[:output_dir]

if inputs[:loverwrite_output]
    outstring = string("output")
else        
    outstring = string("output-",  Dates.format(now(), "dduyyyy-HHMMSS"))
end
if user_defined_output_dir == "none"
    OUTPUT_DIR = joinpath(case_name_dir, outstring)
    inputs[:output_dir] = OUTPUT_DIR
else
    OUTPUT_DIR = joinpath(user_defined_output_dir, parsed_case_name, outstring)
    inputs[:output_dir] = OUTPUT_DIR
end
if !isdir(OUTPUT_DIR)
    mkpath(OUTPUT_DIR)
end

#--------------------------------------------------------
# Save a copy of user_inputs.jl for the case being run 
#--------------------------------------------------------
if Sys.iswindows() == false
    run(`$cp $user_input_file $OUTPUT_DIR`)
end

#--------------------------------------------------------
# use Metal (for apple) or CUDA (non apple) if we are on GPU
#--------------------------------------------------------
if cpu == false
    if Sys.isapple()
        using Metal
    elseif Sys.islinux()
        using CUDA
    end
end

driver(inputs, # input parameters from src/user_input.jl
       OUTPUT_DIR,
       TFloat)
