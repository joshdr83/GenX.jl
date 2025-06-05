function load_inertia_requirement!(setup::Dict, path::AbstractString, inputs::Dict)
    scale_factor = setup["ParameterScale"] == 1 ? ModelScalingFactor : 1
    filename = "inertia_req.csv"
    df = load_dataframe(joinpath(path, filename))
    inputs["InertiaReq"] = df[:, :MW_s] ./ scale_factor
    println(filename * " Successfully Read!")
    return nothing
end
