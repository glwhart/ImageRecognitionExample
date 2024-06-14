include("image_classes.jl")

using FileIO
using ProgressMeter

directory = "image_classes/"
@showprogress for idx in 1:150
    img = Gray.(make_flowers())
    filename = directory * "flower" * lpad(idx, 3, '0') * ".png"
    save(filename, img)
end

@showprogress for idx in 1:150
    rank = rand(2:50)
    img = Gray.(rand_rank(rank))
    filename = directory * "rankN" * lpad(idx, 3, '0') * ".png"
    save(filename, img)
end



