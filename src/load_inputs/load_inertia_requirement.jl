@doc raw"""
    load_inertia_requirement!(setup::Dict, path::AbstractString, inputs::Dict)

Read input parameters related to system inertia requirements.
The file `inertia_req.csv` must contain a column `MW_s` with
hourly inertia requirement values (in MW\*s). If time domain reduction
is enabled and a reduced version of this file exists in the
`TDR_results` folder, that file will be loaded instead.
"""
function load_inertia_requirement!(setup::Dict, path::AbstractString, inputs::Dict)
    filename = "inertia_req.csv"
    TDR_directory = joinpath(path, setup["TimeDomainReductionFolder"])
    my_dir = get_systemfiles_path(setup, TDR_directory, path)
    file_path = joinpath(my_dir, filename)
    if isfile(file_path)
        df = load_dataframe(file_path)
        inputs["InertiaRequirementTS"] = df[!, :MW_s]
        println(filename * " Successfully Read!")
    else
        @warn filename * " not found in " * my_dir
        inputs["InertiaRequirementTS"] = zeros(Float64, inputs["T"])
    end
end
