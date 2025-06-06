@doc raw"""
    load_inertia_requirement!(setup::Dict, path::AbstractString, inputs::Dict)

Read input parameters related to system inertia requirements.
The file `inertia_req.csv` must include a column `MW_s` with
hourly inertia requirement values (in MW*s). Any additional columns
are ignored.
"""
function load_inertia_requirement!(setup::Dict, path::AbstractString, inputs::Dict)
    filename = "inertia_req.csv"
    file_path = joinpath(path, setup["PoliciesFolder"], filename)

    if !isfile(file_path)
        error(filename * " not found in " * file_path)
    end

    df = load_dataframe(file_path)

    # if :MW_s ∉ names(df)
    #     error("inertia_req.csv data file is missing column MW_s")
    # end

    inputs["InertiaRequirementTS"] = df[!, :MW_s]
    println(filename * " Successfully Read!")
end
