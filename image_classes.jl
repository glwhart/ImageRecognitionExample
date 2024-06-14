using LinearAlgebra
using Images
using Infiltrator
using ImageFiltering
using Random

function make_flowers(img_dims=(512, 512); 
        background=0, 
        poss_vals=LinRange(0, 1, 10000), 
        N_flowers=5
    )
    possible_petals = collect(4:2:12)
    petals = [rand(possible_petals) for flower in 1:N_flowers]
    
    centers = [img_dims .* [rand(), rand()] for flower in 1:N_flowers]
    
    possible_radii = collect(15:30)
    radii = [rand(possible_radii) for flower in 1:N_flowers]

    possible_puffiness_scales = LinRange(1, 5, 500)
    puffiness = [r * rand(possible_puffiness_scales) for r in radii]

    # Functions defining the radius around the respective centers
    rad_funcs = [θ -> r*sin(p*θ)+puff 
                        for (p, r, puff) in zip(petals, radii, puffiness)]
    
    # θ = arctan(Δy / Δx)
    in_criteria = [(coord) -> 
                     norm(coord - center) <= 
                     rf(atan((coord[2] - center[2]) / (coord[1] - center[1])))
                     for (center, rf) in zip(centers, rad_funcs)]
                     
    image = fill(Float64(background), img_dims)
    flower_vals = [rand(poss_vals) for flower in 1:N_flowers]
    for x in 1:img_dims[1], y in 1:img_dims[2]
        for (crit, val) in zip(in_criteria, flower_vals)
            if crit([x, y])   image[x, y] = val   end
        end
    end

    return image
end

using Random

""" Generate an m×n matrix with rank `rank` using outer products of Gaussian vectors. """
function rand_rank(rank, m=512, n=512)
    # generate X, an m×n low-rank matrix.
    X = zeros(m,n)
    for i in 1:rank
        X += randn(m) * randn(n)' # add a rank-1 matrix to X `rank` times
    end
    return _rescale(X)
end

""" Rescale a matrix to have values all between 0 and 1. """
function _rescale(M)
    M_min = minimum(M)
    M_max = maximum(M)
    return (M .- (M_min)) ./ (M_max - M_min)
end        