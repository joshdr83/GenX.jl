@doc raw"""
    inertia_requirement!(EP::Model, inputs::Dict, setup::Dict)

Create minimum inertia requirement constraints if specified.
The hourly system inertia provided by each resource is calculated as
`eTotalCap[y] * pP_Max[y,t] * mw_s_per_mw(gen[y])` for resources without unit
commitment and `vCOMMIT[y,t] * cap_size(gen[y]) * pP_Max[y,t] * mw_s_per_mw(gen[y])`
for resources with unit commitment.
The sum of inertia across resources in each hour must meet or exceed the
requirements loaded from `min_inertia_req.csv`.
"""
function inertia_requirement!(EP::Model, inputs::Dict, setup::Dict)
    println("Inertia Requirement Module")
    G = inputs["G"]
    T = inputs["T"]
    gen = inputs["RESOURCES"]
    COMMIT = inputs["COMMIT"]
    pP_Max = inputs["pP_Max"]

    @expression(EP, eInertia[t = 1:T], begin
        sum(
            (y in COMMIT ?
                 mw_s_per_mw(gen[y]) * pP_Max[y, t] * cap_size(gen[y]) * EP[:vCOMMIT][y, t] :
                 mw_s_per_mw(gen[y]) * pP_Max[y, t] * EP[:eTotalCap][y]
            ) for y in 1:G)
    end)

    @constraint(EP,
        cInertiaRequirement[t = 1:T],
        EP[:eInertia][t] >= inputs["MinInertiaReq"][t])
end
