function resource_inertia!(EP::Model, inputs::Dict, setup::Dict)
    gen = inputs["RESOURCES"]
    T = inputs["T"]
    G = inputs["G"]
    COMMIT = inputs["COMMIT"]
    scale_factor = setup["ParameterScale"] == 1 ? ModelScalingFactor : 1.0
    availability = inputs["pP_Max"]
    if !isempty(COMMIT)
        @expression(EP, eInertiaCommit[t in 1:T],
            sum(EP[:vCOMMIT][y, t] * cap_size(gen[y]) * availability[y, t] *
                scale_factor * mw_s_per_mw(gen[y]) for y in COMMIT))
        add_similar_to_expression!(EP[:eInertiaBalance], eInertiaCommit)
    end
    NON_COMMIT = setdiff(1:G, COMMIT)
    if !isempty(NON_COMMIT)
        @expression(EP, eInertiaAlways[t in 1:T],
            sum(EP[:eTotalCap][y] * availability[y, t] * scale_factor *
                mw_s_per_mw(gen[y]) for y in NON_COMMIT))
        add_similar_to_expression!(EP[:eInertiaBalance], eInertiaAlways)
    end
    return nothing
end
