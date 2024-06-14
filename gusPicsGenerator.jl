function sineSpots(N)
    xs = rand()*2π
    ys = rand()*2π
    kx = 2π/N*rand(1:4)
    ky = 2π/N*rand(1:4)
    return Gray.((1 .+hcat([[sin(kx*i+xs)*sin(ky*j+ys) for i ∈ 1:N] for j ∈ 1:N]...))./2)
end

function rank1(N)
    x = rand(N)
    y = rand(N)
    return Gray.(x * y')
end

function noise(N)
    return Gray.(rand(N,N))
end

N = 150
for i ∈ 1:150
    save("images/sineSpots$(lpad(i,3,'0')).png",sineSpots(N))
end
for i ∈ 1:150
    save("images/rankone$(lpad(i,3,'0')).png",rank1(N))
end
for i ∈ 1:150
    save("images/noise$(lpad(i,3,'0')).png",noise(N))
end

