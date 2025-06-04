@doc raw"""
    inertia_requirement!(EP::Model, inputs::Dict, setup::Dict)

Enforces a system inertia requirement in each time step. The total inertia
contributed by online units must be at least the value specified in
`inertia_req.csv`.
"""
function inertia_requirement!(EP::Model, inputs::Dict, setup::Dict)
    println("Inertia Requirement Module")
    T = inputs["T"]
    req = inputs["InertiaReq"]
    nreq = length(req)
    @constraint(EP, cInertiaReq[t = 1:T], EP[:eInertiaBalance][t] >= req[min(t, nreq)])
end
