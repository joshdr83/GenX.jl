@doc raw"""
    load_inertia_requirement!(path::AbstractString, inputs::Dict, setup::Dict)

Read input parameters related to minimum system inertia requirements.
"""
function load_inertia_requirement!(path::AbstractString, inputs::Dict, setup::Dict)
    filename = "min_inertia_req.csv"
    TDR_directory = joinpath(dirname(path), setup["TimeDomainReductionFolder"])
    my_dir = get_policiesfiles_path(setup, TDR_directory, path)
    df = load_dataframe(joinpath(my_dir, filename))
    inputs["MinInertiaReq"] = df[!, :MW_s]
    scale_factor = setup["ParameterScale"] == 1 ? ModelScalingFactor : 1
    inputs["MinInertiaReq"] /= scale_factor
    println(filename * " Successfully Read!")
end
