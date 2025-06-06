@doc raw"""
    load_inertia_requirement!(setup::Dict, path::AbstractString, inputs::Dict)

Read input parameters related to system inertia requirements.
The file `inertia_req.csv` must include a column `MW_s` with
hourly inertia requirement values (in MW\*s). Any additional columns
are ignored. If time domain reduction is enabled and a reduced
version of this file exists in the `TDR_results` folder, that file
will be loaded instead.
"""
function load_inertia_requirement!(setup::Dict, path::AbstractString, inputs::Dict)
    filename = "inertia_req.csv"
    tdr_path = joinpath(path, setup["TimeDomainReductionFolder"], filename)
    policy_path = joinpath(path, setup["PoliciesFolder"], filename)

    csv_path = nothing
    if setup["TimeDomainReduction"] == 1 && isfile(tdr_path)
        csv_path = tdr_path
    elseif isfile(policy_path)
        csv_path = policy_path
    else
        @warn filename * " not found in " * policy_path
        inputs["InertiaRequirementTS"] = zeros(Float64, inputs["T"])
        return nothing
    end

    df = load_dataframe(csv_path)

    # normalize column names: remove UTF-8 byte order marks and whitespace,
    # then convert to lowercase
    clean(name) = lowercase(strip(replace(String(name), "\ufeff" => "")))
    rename!(df, Symbol.(clean.(names(df))))
    if :mw_s ∉ names(df)
        cols = join(names(df), ", ")
        error("inertia_req.csv data file is missing column MW_s. Columns found: $cols. File loaded from $(csv_path)")
    end
    inputs["InertiaRequirementTS"] = df[!, :mw_s]
    println(filename * " Successfully Read!")
end
