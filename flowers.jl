using LinearAlgebra
using Images
using Infiltrator

function make_flowers(img_dims=(512, 512); background=0, poss_vals=[0.5, 1], N_flowers=8)
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

#make_flowers()
        