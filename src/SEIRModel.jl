module SEIRModel

using DifferentialEquations

function SEIR!(du, u, p, t)
    S, E, I, R = u
    β, σ, γ, N = p
    du[1] = -β * S * I / N
    du[2] = β * S * I / N - σ * E
    du[3] = σ * E - γ * I
    du[4] = γ * I
end

function setup_SEIR_model(params, u0, tspan)
    prob = ODEProblem(SEIR!, u0, tspan, params)
    return prob
end

end