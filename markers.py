#!/usr/bin/env python3
"""
Adds markers to points on an image.

Usage:

markers image_file output_file x1,y1 [x2,y2 x3,y3 ...]
"""
from matplotlib.pyplot import *
from numpy import *
import matplotlib.image as mpimg
import sys

in_fname = sys.argv[1]
out_fname = sys.argv[2]
pointargs = sys.argv[3:]

def parse_point(pointstring):
    return [int(x) for x in pointstring.split(',')]

points = [parse_point(arg) for arg in pointargs]

img = mpimg.imread(in_fname)
imshow(img)

for i, p in enumerate(points):
    x, y = p[0], 512-p[1]
    plot(x, y, 'wx')
    annotate(str(i+1), (x+6, y+10), color='white')

xlim(xmax=shape(img)[1]-1, xmin=0)
ylim(ymin=shape(img)[0]-1, ymax=0)

xticks([])
yticks([])
savefig(out_fname, bbox_inches='tight', pad_inches=0)
