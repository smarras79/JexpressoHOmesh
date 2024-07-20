using Crayons.Box
using PrettyTables

function mod_inputs_user_inputs!(inputs)

    error_flag::Int8 = 0
    
    #Store parsed arguments xxx into inputs[:xxx]
    _parsedToInputs(inputs, parsed_case_name)
    
    print(GREEN_FG(string(" # Read inputs dict from ", user_input_file, " ... \n")))
    pretty_table(inputs; sortkeys=true, border_crayon = crayon"yellow")    
    print(GREEN_FG(string(" # Read inputs dict from ", user_input_file, " ... DONE\n")))
    
    #
    # Check that necessary inputs exist in the Dict inside .../IO/user_inputs.jl
    #
    mod_inputs_check(inputs, :nop, Int8(4), "w")  #Polynomial order
    
    if(!haskey(inputs, :backend))
        inputs[:backend] = CPU()
    end
    
    if (inputs[:backend] != CPU())
        if (inputs[:backend] == CUDABackend())
            global TInt = Int64
            global TFloat = Float64
            global cpu = false
        else
            global TInt = Int32
            global TFloat = Float32
            global cpu = false
        end
    end
    
    if(!haskey(inputs, :lperiodic_1d))
      inputs[:lperiodic_1d] = false
    end
    
    if(!haskey(inputs, :llaguerre_bc))
      inputs[:llaguerre_bc] = false
    end

    if(!haskey(inputs, :laguerre_tag))
      inputs[:laguerre_tag] = "none"
    end

    if(!haskey(inputs, :lperiodic_laguerre))
      inputs[:lperiodic_laguerre] = false
    end

    if(!haskey(inputs,:llaguerre_1d_right))
      inputs[:llaguerre_1d_right] = false
    end

    if(!haskey(inputs,:llaguerre_1d_left))
      inputs[:llaguerre_1d_left] = false
    end

    if(!haskey(inputs,:laguerre_beta))
      inputs[:laguerre_beta] = 1.0
    end
    
    if(!haskey(inputs,:nop_laguerre))
        inputs[:nop_laguerre] = 18
    end
    
    if(!haskey(inputs,:xfac_laguerre))
        inputs[:xfac_laguerre] = 1.0
    end

    if(!haskey(inputs,:yfac_laguerre))
        inputs[:yfac_laguerre] = 1.0
    end
    
    if(!haskey(inputs,:lwarp))
        inputs[:lwarp] = false
    end

    if(!haskey(inputs,:mount_type))
        inputs[:lagnesi] = "agnesi"
    end

    if(!haskey(inputs,:a_mount))
        inputs[:a_mount] = 10000.0
    end

    if(!haskey(inputs,:h_mount))
        inputs[:h_mount] = 1.0
    end
    
    if(!haskey(inputs,:c_mount))
        inputs[:c_mount] = 0.0
    end

    if(!haskey(inputs,:xscale))
        inputs[:xscale] = 1.0
    end

    if(!haskey(inputs,:yscale))
        inputs[:yscale] = 1.0
    end
    
    if(!haskey(inputs, :xdisp))
        inputs[:xdisp] = 0.0
    end
    
    if(!haskey(inputs, :ydisp))
        inputs[:ydisp] = 0.0
    end

    #
    # Plotting parameters:
    #
    if(!haskey(inputs, :outformat))
        inputs[:outformat] = VTK()
    end   
    #
    # END Plotting parameters:
    #

    
    if(!haskey(inputs, :lexact_integration))
        inputs[:lexact_integration] = false
    end
    
    if(haskey(inputs, :interpolation_nodes))
        
        if(lowercase(inputs[:interpolation_nodes]) == "llg"  ||
            lowercase(inputs[:interpolation_nodes]) == "gll" ||
            lowercase(inputs[:interpolation_nodes]) == "lgl")
            inputs[:interpolation_nodes] = LGL()

        elseif(lowercase(inputs[:interpolation_nodes]) == "lg" ||
            lowercase(inputs[:interpolation_nodes]) == "gl")
            inputs[:interpolation_nodes] = LG()
            
        elseif(lowercase(inputs[:interpolation_nodes]) == "cg" ||
            lowercase(inputs[:interpolation_nodes]) == "gc")
            inputs[:interpolation_nodes] = CG()
            
        elseif(lowercase(inputs[:interpolation_nodes]) == "cgl" ||
            lowercase(inputs[:interpolation_nodes]) == "gcl")
            inputs[:interpolation_nodes] = CGL()
        else
            s = """
                    ERROR in user_inputs.jl --> :interpolation_nodes
                    
                        Chose among:
                         - "lgl"
                         - "lg"
                         - "cg"
                         - "cgl"
                  """
            
            error(s)
        end
    else
        #default are LGL
        inputs[:interpolation_nodes] = LGL()
    end

    if(haskey(inputs, :quadrature_nodes))
        
        if(lowercase(inputs[:quadrature_nodes]) == "llg" ||
            lowercase(inputs[:quadrature_nodes]) == "gll" ||
            lowercase(inputs[:quadrature_nodes]) == "lgl")
            inputs[:quadrature_nodes] = LGL()

        elseif(lowercase(inputs[:quadrature_nodes]) == "lg" ||
            lowercase(inputs[:quadrature_nodes]) == "gl")
            inputs[:quadrature_nodes] = LG()
            
        elseif(lowercase(inputs[:quadrature_nodes]) == "cg" ||
            lowercase(inputs[:quadrature_nodes]) == "gc")
            inputs[:quadrature_nodes] = CG()
            
        elseif(lowercase(inputs[:quadrature_nodes]) == "cgl" ||
            lowercase(inputs[:quadrature_nodes]) == "gcl")
            inputs[:quadrature_nodes] = CGL()
        else
            s = """
                    ERROR in user_inputs.jl --> :quadrature_nodes
                    
                        Chose among:
                         - "lgl"
                         - "lg"
                         - "cg"
                         - "cgl"
                  """
            
            error(s)            
        end
    else
        #default are LGL
        inputs[:quadrature_nodes] = LGL()
    end
    
    if(!haskey(inputs, :output_dir))
        inputs[:output_dir] = "none"
    end
    
    #Grid entries:
    if(!haskey(inputs, :lread_gmsh) || inputs[:lread_gmsh] == false)
        
        mod_inputs_check(inputs, :nsd,  Int8(1), "-")
        mod_inputs_check(inputs, :nelx, "e")
        mod_inputs_check(inputs, :xmin, "e")
        mod_inputs_check(inputs, :xmax, "e")
        mod_inputs_check(inputs, :nely,  Int8(2), "-")
        mod_inputs_check(inputs, :ymin, Float64(-1.0), "-")
        mod_inputs_check(inputs, :ymax, Float64(+1.0), "-")
        mod_inputs_check(inputs, :nelz,  Int8(2), "-")
        mod_inputs_check(inputs, :zmin, Float64(-1.0), "-")
        mod_inputs_check(inputs, :zmax, Float64(+1.0), "-")
        
    else
        mod_inputs_check(inputs, :gmsh_filename, "e")
        
        mod_inputs_check(inputs, :nsd,  Int8(3), "-")
        mod_inputs_check(inputs, :nelx,  Int8(2), "-")
        mod_inputs_check(inputs, :xmin, Float64(-1.0), "-")
        mod_inputs_check(inputs, :xmax, Float64(+1.0), "-")
        mod_inputs_check(inputs, :nely,  Int8(2), "-")
        mod_inputs_check(inputs, :ymin, Float64(-1.0), "-")
        mod_inputs_check(inputs, :ymax, Float64(+1.0), "-")
        mod_inputs_check(inputs, :nelz,  Int8(2), "-")
        mod_inputs_check(inputs, :zmin, Float64(-1.0), "-")
        mod_inputs_check(inputs, :zmax, Float64(+1.0), "-")

        s= string("jexpresso: Some undefined (but unnecessary) user inputs 
                                  MAY have been given some default values.
                                  User needs not to worry about them.")
        
        #@warn s
        
    end #lread_gmsh
   
    #
    # Correct quantities based on a hierarchy of input variables
    #
    # Define default npx,y,z for native grid given
    # values for the user's nelx,y,z
    if(haskey(inputs, :nelx))
        inputs[:npx] = inputs[:nelx] + 1
    else
        inputs[:npx] = UInt8(2)
    end
    if(haskey(inputs, :nely))
        inputs[:npy] = inputs[:nely] + 1
    else
        inputs[:npy] = UInt8(2)
    end
    if(haskey(inputs, :nelz))
        inputs[:npz] = inputs[:nelz] + 1
    else
        inputs[:npz] = UInt8(2)
    end
    
    if (inputs[:nsd] == 1)
        inputs[:npy] = UInt8(1)
        inputs[:npz] = UInt8(1)
    elseif(inputs[:nsd] == 2)
        inputs[:npz] = UInt8(1)
    end

    #Penalty constant for SIPG
    if(!haskey(inputs, :penalty))
        inputs[:penalty] = Float16(0.0) #default kinematic viscosity
    end
    
    
    #------------------------------------------------------------------------
    #To add a new set of governing equations, add a new equations directory
    #to src/equations and call it `ANY_NAME_YOU_WANT` 
    #and add the following lines 
    #
    #elseif (lowercase(equations) == "ANY_NAME_YOU_WANT")
    #inputs[:equations] = ANY_NAME_YOU_WANT()
    #
    #neqs = INTEGER VALUE OF THE NUMBER OF UNKNOWNS for this equations.
    #prinetln( " # neqs     ", neqs)
    #end
    #------------------------------------------------------------------------
    
    #------------------------------------------------------------------------
    # Define neqs based on the equations being solved
    #------------------------------------------------------------------------
    neqs::Int8 = 1
    
    if(!haskey(inputs, :CL))
        # :CL stands for Conservation Law.
        # :CL => CL()  means that we solve dq/dt + \nabla.F(q) = S(q)
        # :CL => NCL() means that we solve dq/dt + u.\nabla(q)= S(q)        
        inputs[:CL] = CL()
    end

    if(!haskey(inputs, :AD))
        inputs[:AD] = ContGal()
    else
        if inputs[:AD] != ContGal() && inputs[:AD] != FD()
            @mystop(" :AD can only be either ContGal() or FD() at the moment.")
        end
    end
    
    if(!haskey(inputs, :loverwrite_output))
        inputs[:loverwrite_output] = false
    end
    
    return inputs
end


function _parsedToInputs(inputs, parsed_case_name)
    #
    # USER: DO NOT MODIFY inputs[:parsed_equations] and inputs[:parsed_case_name]
    #
    inputs[:parsed_case_name] = parsed_case_name
end


function mod_inputs_check(inputs::Dict, key, error_or_warning::String)
    
    if (!haskey(inputs, key))
        s = """
              jexpresso: $key is missing in problems/equations/PROBLEM_NAME/PROBLEM_CASE_NAME/user_inputs.jl
                    """
        if (error_or_warning=="e")
            error(s)
        elseif (error_or_warning=="w")
            @warn s
        end
        error_flag = 1
    end
    
end


function mod_inputs_check(inputs::Dict, key, value, error_or_warning::String)

    if (!haskey(inputs, key))
        s = """
                    jexpresso: $key is missing in .../IO/user_inputs.jl
                    The default value $key=$value will be used.
                    """
        if (error_or_warning=="e")
            error(s)
        elseif (error_or_warning=="w")
            @warn s
        end
        
        #assign a dummy default value
        inputs[key] = value
    end

end

function mod_inputs_print_welcome()

    print(BLUE_FG(" #--------------------------------------------------------------------------------\n"))
    print(BLUE_FG(" # Welcome to ", RED_FG("jexpresso\n")))
    print(BLUE_FG(" # A Julia code to solve conservation laws with continuous spectral elements\n"))
    print(BLUE_FG(" #--------------------------------------------------------------------------------\n"))

end
