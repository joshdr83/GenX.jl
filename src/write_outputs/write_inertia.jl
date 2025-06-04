function write_inertia(path::AbstractString, inputs::Dict, setup::Dict, EP::Model)
    gen = inputs["RESOURCES"]
    G = inputs["G"]
    names = inputs["RESOURCE_NAMES"]
    zones = inputs["R_ZONES"]
    COMMIT = inputs["COMMIT"]
    T = inputs["T"]
    scale_factor = setup["ParameterScale"] == 1 ? ModelScalingFactor : 1.0
    avail = inputs["pP_Max"]
    data = zeros(G, T)
    for y in COMMIT
        data[y, :] .=
            value.(EP[:vCOMMIT][y, :] .* cap_size(gen[y]) .* avail[y, :] .*
                   scale_factor .* mw_s_per_mw(gen[y]))
    end
    NON_COMMIT = setdiff(1:G, COMMIT)
    for y in NON_COMMIT
        data[y, :] .= value.(EP[:eTotalCap][y]) .* avail[y, :] .* scale_factor .*
                       mw_s_per_mw(gen[y])
    end
    df = DataFrame(Resource = names, Zone = zones)
    df.AnnualSum = data * inputs["omega"]
    write_temporal_data(df, data, path, setup, "inertia")
    return nothing
end
