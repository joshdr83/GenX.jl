function write_inertia(path::AbstractString, inputs::Dict, setup::Dict, EP::Model)
    gen = inputs["RESOURCES"]
    resources = inputs["RESOURCE_NAMES"]
    zones = zone_id.(gen)

    G = inputs["G"]
    T = inputs["T"]
    COMMIT = inputs["COMMIT"]
    pP_Max = inputs["pP_Max"]
    weight = inputs["omega"]
    scale_factor = setup["ParameterScale"] == 1 ? ModelScalingFactor : 1

    # Inertia contributed by each resource in each time step
    inertia = zeros(G, T)
    for y in 1:G
        for t in 1:T
            if y in COMMIT
                inertia[y, t] = mw_s_per_mw(gen[y]) * pP_Max[y, t] * cap_size(gen[y]) * value(EP[:vCOMMIT][y, t])
            else
                inertia[y, t] = mw_s_per_mw(gen[y]) * pP_Max[y, t] * value(EP[:eTotalCap][y])
            end
        end
    end
    inertia .*= scale_factor

    df = DataFrame(Resource = resources,
        Zone = zones)
    df.AnnualSum = inertia * weight

    write_temporal_data(df, inertia, path, setup, "inertia")
    return df
end
