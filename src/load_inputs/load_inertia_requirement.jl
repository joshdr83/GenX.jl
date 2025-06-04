@doc raw"""
    load_inertia_requirement!(setup::Dict, path::AbstractString, inputs::Dict)

Read input parameters for system inertia requirements. The file `inertia_req.csv`
should contain a single column `MW_s` with the minimum inertia (in megawatt-seconds)
that must be available each modeled hour.
"""
function load_inertia_requirement!(setup::Dict, path::AbstractString, inputs::Dict)
    filename = "inertia_req.csv"
    # `path` is typically the policies directory. If time domain reduction
    # was performed and a reduced file exists, read that instead.
    casepath = dirname(path)
    tdr_dir = joinpath(casepath, setup["TimeDomainReductionFolder"])
    if setup["TimeDomainReduction"] == 1 && isfile(joinpath(tdr_dir, filename))
        df = load_dataframe(joinpath(tdr_dir, filename))
    else
        df = load_dataframe(joinpath(path, filename))
    end
    req = Vector{Float64}(df[:, :MW_s])
    scale_factor = setup["ParameterScale"] == 1 ? ModelScalingFactor : 1.0
    req ./= scale_factor # convert to GW-s if scaled
    inputs["InertiaReq"] = req
    println(filename * " Successfully Read!")
    return nothing
end
