using Plots

S = 100
r = 0.08
T = 1
n = 10000
sigma = 0.3
h = T/n

u = exp(r*h + sigma * sqrt(h))
d = exp(r*h - sigma * sqrt(h))

p_star = (exp(r*h) - d) / (u - d)

path = Array{Float64}(undef,n + 2)

#add in the starting price
path[1] = S

for k in 2:n+2
    if rand() < p_star
        #then we go up
        path[k] = path[k-1] * u
    else
        path[k] = path[k-1] * d
    end
end

plot(path)
