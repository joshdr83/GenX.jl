function write_inertia(path::AbstractString, inputs::Dict, setup::Dict, EP::Model)
    if !haskey(inputs, "InertiaReq")
        @info "No inertia data to write"
        return nothing
    end
    inertia = value.(EP[:eInertia])
    df = DataFrame(Inertia_MW_s = inertia)
    CSV.write(joinpath(path, "hourly_inertia.csv"), df)
    return nothing
end
