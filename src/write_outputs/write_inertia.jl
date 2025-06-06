function write_inertia(path::AbstractString, inputs::Dict, setup::Dict, EP::Model)
    T = inputs["T"]
    G = inputs["G"]
    gen = inputs["RESOURCES"]
    COMMIT = inputs["COMMIT"]
    pP = inputs["pP_Max"]
    scale_factor = setup["ParameterScale"] == 1 ? ModelScalingFactor : 1.0

    inertia = zeros(T)
    for y in 1:G
        inertia_const = get(gen[y], :mw_s_per_mw, 0.0)
        if inertia_const == 0.0
            continue
        end
        cap = value(EP[:eTotalCap][y]) * scale_factor
        avail = pP[y, :]
        if y in COMMIT
            inertia .+= cap * inertia_const .* avail .* value.(EP[:vCOMMIT][y, :])
        else
            inertia .+= cap * inertia_const .* avail
        end
    end
    df = DataFrame(AnnualSum = sum(inertia .* inputs["omega"]))
    df = hcat(df, DataFrame(transpose(inertia), :auto))
    names!(df, [:AnnualSum; Symbol.("t" .* string.(1:T))])
    CSV.write(joinpath(path, "inertia.csv"), dftranspose(df, false), writeheader=false)
    if setup["OutputFullTimeSeries"] == 1 && setup["TimeDomainReduction"] == 1
        write_full_time_series_reconstruction(path, setup, df, "inertia")
        @info("Writing Full Time Series for inertia")
    end
    return df
end
