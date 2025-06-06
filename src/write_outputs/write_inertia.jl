function write_inertia(path::AbstractString, inputs::Dict, setup::Dict, EP::Model)
    gen = inputs["RESOURCES"]
    G = inputs["G"]
    T = inputs["T"]
    COMMIT = inputs["COMMIT"]
    pP_Max = inputs["pP_Max"]
    weight = inputs["omega"]
    scale_factor = setup["ParameterScale"] == 1 ? ModelScalingFactor : 1

    inertia = zeros(1, T)
    for t in 1:T
        total = 0.0
        for y in 1:G
            if y in COMMIT
                total += mw_s_per_mw(gen[y]) * pP_Max[y, t] * cap_size(gen[y]) * value(EP[:vCOMMIT][y, t])
            else
                total += mw_s_per_mw(gen[y]) * pP_Max[y, t] * value(EP[:eTotalCap][y])
            end
        end
        inertia[1, t] = total * scale_factor
    end

    df = DataFrame(Resource = ["System"], Zone = [0], AnnualSum = inertia * weight)
    write_temporal_data(df, inertia, path, setup, "inertia")
    return df
end
