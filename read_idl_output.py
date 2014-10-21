#!/usr/bin/python

from numpy import *
from matplotlib.pyplot import *
from glob import glob

# Read IDL output file
filename = '/home/chris/solar/solar-data-programs/velocity_output.dat'
text = ''

with open(filename) as f:
    for line in f:
        text += line

arr1 = text.split('\n\n\n')

arr = [entry.split('\n') for entry in arr1 if entry != []]
arr = arr [:-1]

a = array([[[float(s) for s in string.split()] for string in entry] for entry in arr])

# Draw images
window_scale = True

pathname = '/home/chris/solar/solar-data-programs/pictures/window*.png'
images = [imread(path) for path in sort(glob(pathname))]
composite = concatenate(images, axis=1)
implot = imshow(composite)

# Construct scatter plots
if window_scale:
    for i in range(len(a[0,:,0])):
        xs = array([x + i*120 for x in a[0, i, :]])
        ys = array(a[1, i, :])
        vs = array(a[3, i, :])
        maxv = np.max(abs(vs))
        norm=Normalize(vmin=-maxv, vmax=maxv)
        scatter(xs, ys, marker='o', c=vs, alpha=1, cmap='Spectral', norm=norm, lw=0)
else:
    xs = []
    ys = []
    vs = []
    for i in range(len(a[0,:,0])):
        xs.append([x + i*120 for x in a[0, i, :]])
        ys.append(a[1, i, :])
        vs.append(a[3, i, :])
    xs = array(xs)
    ys = array(ys)
    vs = array(vs)

    maxv = np.max(abs(vs))

    scaled_vs = ((vs / maxv) + 1) / 2

    norm=Normalize(vmin=-maxv, vmax=maxv)
    scatter(xs, ys, marker='|', c=scaled_vs, alpha=1, cmap='Spectral')
show()
