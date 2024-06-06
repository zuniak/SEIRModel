module MyOptimization

using ..Interventions
using Optimization
using OptimizationMetaheuristics

function f(lockdown_and_vaccination, p)
    params = p[1]
    u0 = p[2]
    tspan = (0.0, 160.0)
    prob = Interventions.setup_intervention_model(params, u0, tspan, lockdown_intensity=lockdown_and_vaccination[1], vaccination_rate=lockdown_and_vaccination[2])
    sol = solve(prob)
    return sum(sol[:, 3])
end


function optimize_lockdown_and_vaccination(params, u0, lockdown_and_vaccination)
    p = [params, u0]
    prob = Optimization.OptimizationProblem(f, lockdown_and_vaccination, p, lb = [0.0, 0.0], ub = [1.0, 1.0])
    sol = solve(prob, ECA(), maxiters = 100000, maxtime = 1000.0)
    return sol
end

end