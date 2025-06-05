function load_inertia_req!(setup::Dict, path::AbstractString, inputs::Dict)
    filename = "inertia_req.csv"
    if !isfile(joinpath(path, filename))
        @info "$(filename) not found. Skipping inertia requirement loading"
        return nothing
    end
    df = load_dataframe(joinpath(path, filename))
    rename!(df, lowercase.(names(df)))
    validate_df_cols(df, filename, ["mw_s"])
    inputs["InertiaReq"] = collect(skipmissing(df.mw_s))
    println(filename * " Successfully Read!")
    return nothing
end
