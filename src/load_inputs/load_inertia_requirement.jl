@doc raw"""
    load_inertia_requirement!(path::AbstractString, inputs::Dict, setup::Dict)

Read input parameters related to minimum system inertia requirements.
"""
function load_inertia_requirement!(path::AbstractString, inputs::Dict, setup::Dict)
    filename = "min_inertia_req.csv"
    df = load_dataframe(joinpath(path, filename))
    inputs["MinInertiaReq"] = df[!, :MW_s]
    scale_factor = setup["ParameterScale"] == 1 ? ModelScalingFactor : 1
    inputs["MinInertiaReq"] /= scale_factor
    println(filename * " Successfully Read!")
end
