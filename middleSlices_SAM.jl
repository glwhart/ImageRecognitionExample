# Install PyCall
using PyCall
PyCall.python
# To get the path of the current Python executable for Julia 
# shell> source /Users/glh43/.julia/conda/3/bin/activate
# shell> pip install numpy
# shell> pip install torch
# shell> pip install torchvision
# shell> pip install git+https://github.com/facebookresearch/segment-anything.git
sam = pyimport("segment_anything")
using Images
img = load("images/middle_slice.png")
model = sam.sam_model_registry["vit_h"]("/Users/glh43/Downloads/sam_vit_h_4b8939.pth");
pred = sam.SamPredictor(model)
# julia> pyimport_conda("cv2","opencv-python")
cv2=pyimport("cv2")
img = cv2.imread("images/middle_slice.png")
t = pred.set_image(img)
mask,_,_ = pred.predict()

adjust_histogram(Equalization(),load("images/middle_slice.png"),20)


using LinearAlgebra
jimg = Images.load("images/middle_slice.png")
rank(Gray.(jimg))
using Plots
default(legend=false,msw=0,ms=2)
scatter(svdvals(Gray.(jimg)),yscale=:log10)
rm=randn(369,369)
heatmap(Gray.(rm))
rank(Gray.(rm))
scatter(svdvals(Gray.(rm)),yscale=:log10)                                  

allslices = [load("all_middle_slices_common/"*i) for i in readdir("all_middle_slices_common/")]
save("all.gif",allslices,framerate=3)

using Images
using FFMPEG
imagesdirectory = "all_middle_slices_common/"
framerate = 3
gifname = "output.mp4"
#[cp(imagesdirectory*j,imagesdirectory*lpad(i,4,'0')*".png") for (i,j) in enumerate(readdir(imagesdirectory))]
FFMPEG.ffmpeg_exe(`-framerate $(framerate) -f image2 -i $(imagesdirectory)%4d.png -preset slower -y $(gifname)`)

rx = r"\d{4}\.png" # gpt gave me this, but mine is simpler. rx = r"\b\d{4}\b.*\.png\b" # \b is word boundary
im = [load(imagesdirectory*i) for i in readdir("all_middle_slices_common/") if occursin(rx,i)];
rim = [rank(i) for i in im]
plot(rim)
histogram(N0f8.(vec(im[31])))