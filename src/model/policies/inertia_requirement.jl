function inertia_requirement!(EP::Model, inputs::Dict, setup::Dict)
    if setup["UCommit"] < 1
        return
    end
    println("Inertia Requirement Module")
    T = inputs["T"]
    gen = inputs["RESOURCES"]
    COMMIT = inputs["COMMIT"]
    req = inputs["InertiaReq"]
    pP = inputs["pP_Max"]
    @expression(EP, eInertia[t=1:T], sum(
        EP[:eTotalCap][y] * pP[y, t] * mw_s_per_mw(gen[y]) * (y in COMMIT ? EP[:vCOMMIT][y, t] : 1.0)
        for y in 1:length(gen)))
    @constraint(EP, cInertia[t=1:T], eInertia[t] >= req[t])
end
