module Interventions

using ..SEIRModel
using DifferentialEquations

function apply_lockdown!(params, lockdown_intensity)
    params[1] *= (1 - lockdown_intensity)
end


function apply_vaccination!(u0, vaccination_rate)
    S, E, I, R = u0
    vaccinated = S * vaccination_rate
    u0[1] -= vaccinated
    u0[4] += vaccinated
end

function setup_intervention_model(params, u0, tspan; lockdown_intensity=0.0, vaccination_rate=0.0)
    p = collect(params)
    if lockdown_intensity > 0.0
        apply_lockdown!(p, lockdown_intensity)
    end
    if vaccination_rate > 0.0
        apply_vaccination!(u0, vaccination_rate)
    end
    prob = ODEProblem(SEIRModel.SEIR!, u0, tspan, p)
    return prob
end

end
