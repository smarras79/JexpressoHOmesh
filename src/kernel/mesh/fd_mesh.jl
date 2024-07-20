using WriteVTK

Base.@kwdef mutable struct St_mesh_fd
    x::Float64
    y::Float64
    #z::Float64
    boundary::Bool  # true if the point is a boundary point, false otherwise
    
end

function create_mesh(nx::Int, ny::Int, x_min::Float64, x_max::Float64, y_min::Float64, y_max::Float64)

    #Ni, Nj, Nk = 6, 8, 11
    #x = [i / Ni * cospi(3/2 * (j - 1) / (Nj - 1)) for i = 1:Ni, j = 1:Nj, k = 1:Nk]
    #y = [i / Ni * sinpi(3/2 * (j - 1) / (Nj - 1)) for i = 1:Ni, j = 1:Nj, k = 1:Nk]
    #z = [(k - 1) / Nk for i = 1:Ni, j = 1:Nj, k = 1:Nk]

    
    dx = (x_max - x_min) / (nx - 1)
    dy = (y_max - y_min) / (ny - 1)
    
    mesh = Array{St_mesh_fd}(undef, nx, ny)
    
    for i in 1:nx
        for j in 1:ny
            x = x_min + (i-1) * dx
            y = y_min + (j-1) * dy
            #z = z_min + (k-1) * dz
            is_boundary = (i == 1 || i == nx || j == 1 || j == ny)
            mesh[i, j] = St_mesh_fd(x, y, is_boundary)
        end
    end
    
    return mesh
end

function create_connectivity(nx::Int, ny::Int)
    connectivity = []
    for j in 1:ny-1
        for i in 1:nx-1
            push!(connectivity, [i + (j-1)*nx, i+1 + (j-1)*nx, i+1 + j*nx, i + j*nx] .- 1)
        end
    end
    return connectivity
end

function write_mesh_to_vtk(mesh::Array{St_mesh_fd, 2}, filename::String)
    nx, ny = size(mesh)
    x_coords       = [mesh[i, j].x for j in 1:ny, i in 1:nx]
    y_coords       = [mesh[i, j].y for j in 1:ny, i in 1:nx]
    boundary_flags = [mesh[i, j].boundary for j in 1:ny, i in 1:nx]

    points = hcat(vec(x_coords), vec(y_coords), zeros(nx * ny))
    connectivity = create_connectivity(nx, ny)
    
    vtk_grid(filename, x_coords, y_coords) do vtk
        vtk["boundaries"] =  Int.(boundary_flags)
    end
end

# Example Usage
nx = 10
ny = 10
x_min = 0.0
x_max = 1.0
y_min = 0.0
y_max = 1.0

mesh = create_mesh(nx, ny, x_min, x_max, y_min, y_max)

# Write the mesh to a VTK file
filename = "mesh"
write_mesh_to_vtk(mesh, filename)

