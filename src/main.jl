include("SEIRModel.jl")
include("Interventions.jl")
include("MyOptimization.jl")


using .SEIRModel
using .Interventions
using .MyOptimization
using DifferentialEquations
using Plots

β = 0.5 # Wskaźnik transmisji - szybkość zakażania podatnych osób.
σ = 0.02 # Wskaźnik inkubacji - tempo przejścia z wystawienia na zakażenie do zakaźności.
γ = 0.01 # Wskaźnik wyzdrowienia - tempo wyzdrowienia i odporności.
N = 1000 # Całkowita liczba populacji 
params = (β, σ, γ, N)

S = 999.0 # Osoby podatne na zakażenie, bez odporności.
E = 1.0 # Osoby zakażone, ale jeszcze bezobjawowe, w okresie inkubacji.
I = 0.0 # Osoby z objawami choroby, zdolne do zarażania.
R = 0.0 # Osoby, które wyzdrowiały lub zmarły z powodu choroby, stając się odpornymi na dalsze zakażenie.
u0 = [S, E, I, R]
tspan = (0.0, 500.0)


u1 = u0[:]
prob1 = SEIRModel.setup_SEIR_model(params, u1, tspan)
sol1 = solve(prob1)
plot(sol1, title="Normal SEIR model", label=["S" "E" "I" "R"], color=["blue" "green" "red" "purple"])

u2 = u0[:]
prob2 = Interventions.setup_intervention_model(params, u2, tspan, lockdown_intensity=0.5)
sol2 = solve(prob2)

u3 = u0[:]
prob3 = Interventions.setup_intervention_model(params, u3, tspan, vaccination_rate=0.1)
sol3 = solve(prob3)

u4 = u0[:]
prob4 = Interventions.setup_intervention_model(params, u4, tspan, lockdown_intensity=0.3, vaccination_rate=0.2)
sol4 = solve(prob4)

p1 = plot(sol1, title="No Intervention", color=["blue" "green" "red" "purple"],label="", titlefont=font(8))
p2 = plot(sol2, title="Lockdown Intensity = 0.5", color=["blue" "green" "red" "purple"],label="", titlefont=font(8))
p3 = plot(sol3, title="Vaccination Rate = 0.1", color=["blue" "green" "red" "purple"],label="", titlefont=font(8))
p4 = plot(sol4, title="Lockdown Intensity = 0.3, Vaccination Rate = 0.2", color=["blue" "green" "red" "purple"],label="", titlefont=font(6))

all = plot(p1, p2, p3, p4, layout=(2, 2))

p = plot(title="SEIR Model")

plot!(p, sol1, label="", color=["blue" "green" "red" "purple"], linewidth=0.3)
plot!(p, sol2, label="", color=["blue" "green" "red" "purple"], linewidth=0.6)
plot!(p, sol3, label="", color=["blue" "green" "red" "purple"], linewidth=1.2)
plot!(p, sol4, label="", color=["blue" "green" "red" "purple"], linewidth=2.4)

display(p)


u5 = [S, E, I, R]
optimized_lockdown_intensity, optimized_vaccination_rate = MyOptimization.optimize_lockdown_and_vaccination(params, u5, tspan)
u6 = [S, E, I, R]
prob6 = Interventions.setup_intervention_model(params, u6, tspan, lockdown_intensity=optimized_lockdown_intensity, vaccination_rate=optimized_vaccination_rate)
sol6 = solve(prob6)
plot(sol6, label=["S" "E" "I" "R"], color=["blue" "green" "red" "purple"], linewidth=2)
plot!(sol1, label="", color=["blue" "green" "red" "purple"], linewidth=0.3)
annotate!(100, 1000, text("Optimized Lockdown Intensity: $optimized_lockdown_intensity", :left, 10))
annotate!(100, 950, text("Optimized Vaccination Rate: $optimized_vaccination_rate", :left, 10))
