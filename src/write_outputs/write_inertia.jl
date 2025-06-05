function write_inertia(path::AbstractString, inputs::Dict, setup::Dict, EP::Model)
    T = inputs["T"]
    scale_factor = setup["ParameterScale"] == 1 ? ModelScalingFactor : 1
    inertia = value.(EP[:eInertia]) * scale_factor
    df = DataFrame(Time_Index = 1:T, Inertia_MW_s = inertia)
    CSV.write(joinpath(path, "hourly_inertia.csv"), df)
    return df
end
