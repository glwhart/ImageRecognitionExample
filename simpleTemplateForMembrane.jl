using Images
using Plots
# Got this picture from Braxton
img1=load("data/keyimg_ps2014-06-30-39.jpg")
# The number of gray scale values is < 256. And they seem to be "quantized". Maybe the image was compressed
histogram(vec(convert.(Float64,img1)),yscale=:log10,nbins=256)
#Here's a different bacterial tomogram.  Same problem.
img2=Gray.(load("images/bacterio01.png"))
histogram(vec(convert.(Float64,img2)),yscale=:log10,nbins=256)
#Rotating the images it's size. What's the best way to have the template stay a fixed size? Or can the same operation be done with a template that changes size?
r1img1=imrotate(img1,π/4)
size(r1img1)
size(img1)
# This image was grabbed fresh from a tomogram by Braxton.  It's a slice through the middle of a bacterium. It also has the problem of having a small number of dominant gray scale values.
img3=Gray.(load("images/middle_slice.png"))
histogram(vec(convert.(Float64,img3)),yscale=:log10,nbins=256)
raw3 = vec(convert.(Float64,img3))
unique(raw3)
size(img3)
img4=Gray.(load("images/middle_slice2.png"))
raw4 = vec(convert.(Float64,img4))
unique(raw4)
histogram(raw4,yscale=:log10,nbins=256,size=(800,500))
img5=Gray.(load("images/middle_slice3.png"))
histogram(vec(convert.(Float64,img5)),yscale=:log10,nbins=256)
raw5 = vec(convert.(Float64,img5))
# This is actually a tilt image rather than a slice from a reconstructed tomogram.  It doesn't seem to have the "quantized" values but it has a small dynamic range, minus some enormous outliers.
tilt=load("images/middle_slice_tilt.png")
histogram(vec(convert.(Float64,tilt)),yscale=:log10,nbins=256)
rawtilt = vec(convert.(Float64,tilt))
histogram(min.(vec(convert.(Float64,tilt)),.0902),yscale=:log10,nbins=256)
# It's a bit tricky to figure out how to do mathematical operations on the pixel values. They are of type N0f8 which is imported with Images package. 
# This operation truncates the highest 6 values in the image, then rescales things over 0..1
Gray.(N0f8.(min.(tilt,.0902)/.0902))

# Pick a square out of the middle of img1 to make a template
tmpl=img1[390:420,390:420];
hm = 50*ones(size(img1,1)-size(tmpl,1),size(img1,2)-size(tmpl,2));
for r in 0:π/2:3π/2
    tp = imrotate(tmpl,r)
for i in 1:size(img1,1)-size(tp,1)
    for j in 1:size(img1,2)-size(tp,2)
        v = norm(img1[i:i+size(tp,1)-1,j:j+size(tp,2)-1] - tp)
        v < hm[i,j] ? hm[i,j] = v : nothing
    end
end
end
histogram(vec(hm),yscale=:log10,nbins=256)
heatmap(hm[end:-1:1,:],aspect_ratio=1,size=(1200,1200))
