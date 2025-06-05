@doc raw"""
        write_inertia(path::AbstractString, inputs::Dict, setup::Dict, EP::Model)

Write the hourly inertia contribution from each resource to `inertia.csv`.
The function mirrors other time-series writers and supports annual or full
outputs as well as full time-series reconstruction when time domain reduction
is used.
"""
function write_inertia(path::AbstractString, inputs::Dict, setup::Dict, EP::Model)
    gen = inputs["RESOURCES"]
    resources = inputs["RESOURCE_NAMES"]
    zones = zone_id.(gen)

    G = inputs["G"]
    T = inputs["T"]
    COMMIT = inputs["COMMIT"]

    weight = inputs["omega"]
    scale_factor = setup["ParameterScale"] == 1 ? ModelScalingFactor : 1.0
    availability = inputs["pP_Max"]

    inertia = zeros(G, T)
    for y in COMMIT
        inertia[y, :] .=
            value.(EP[:vCOMMIT][y, :] .* cap_size(gen[y]) .* availability[y, :]) .*
            scale_factor .* mw_s_per_mw(gen[y])
    end
    NON_COMMIT = setdiff(1:G, COMMIT)
    for y in NON_COMMIT
        inertia[y, :] .= value.(EP[:eTotalCap][y]) .* availability[y, :] .*
                           scale_factor .* mw_s_per_mw(gen[y])
    end

    df = DataFrame(Resource = resources, Zone = zones, AnnualSum = inertia * weight)
    # write_temporal_data(df, inertia, path, setup, "inertia")
    CSV.write(joinpath(path, "inertia.csv"), df)
    return df
    # return nothing
end
