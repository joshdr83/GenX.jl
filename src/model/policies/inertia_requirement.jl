@doc raw"""
    inertia_requirement!(EP::Model, inputs::Dict, setup::Dict)

Create hourly inertia requirement constraint if `InertiaRequirement` is
activated in the settings. The required inertia time series is read
from `inertia_req.csv` and stored in `inputs["InertiaRequirementTS"]`.
Each resource may contribute inertia proportional to its installed
capacity, an attribute `mw_s_per_mw`, and its hourly availability
profile. Resources with unit commitment contribute only when committed.
"""
function inertia_requirement!(EP::Model, inputs::Dict, setup::Dict)
    println("Inertia Requirement Module")
    T = inputs["T"]
    G = inputs["G"]
    gen = inputs["RESOURCES"]
    COMMIT = inputs["COMMIT"]
    pP = inputs["pP_Max"]
    scale_factor = setup["ParameterScale"] == 1 ? ModelScalingFactor : 1.0

    mw_s = [get(gen[y], :mw_s_per_mw, 0.0) for y in 1:G]

    @expression(EP, eInertiaBalance[t = 1:T],
        sum(EP[:eTotalCap][y] * scale_factor * mw_s[y] * pP[y, t] *
            (y in COMMIT ? EP[:vCOMMIT][y, t] : 1) for y in 1:G))

    @constraint(EP,
        cInertiaRequirement[t = 1:T],
        EP[:eInertiaBalance][t] >= inputs["InertiaRequirementTS"][t])
end

