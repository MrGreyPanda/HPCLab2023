function save_csv_mats()
    meshes = ["CH-4468", "CL-13042", "GB-5946", "GR-3117", "NO-9935", "RU-40527", "VN-4031"]

    for mesh in meshes
        path = joinpath(dirname(@__DIR__), "Meshes", "Countries", "csv", mesh)
        A, coords = read_csv_graph(path)
        path_file = mesh * "_graph.mat"

        
        # Save the matrices to a .mat file
        file = matopen(path_file, "w")
    
        write(file, "A", A)
        write(file, "coords", coords)
        close(file)
        
    end
end
