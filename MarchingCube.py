#  Authors: He "Crane" Chen, Misha Kazhdan
#  hchen136@jhu.edu
#  Johns Hopkins University, 2021

import trimesh
from skimage import measure
import scipy
from scipy import io

data = scipy.io.loadmat('indicator_function.mat')
indicator_function = data['output'] * (-1)
# isovalue = 4.3222e-11 # fox v1
# isovalue = 1.3747e-15 # fox v2
isovalue = 6.0054e-11 # fox v3
# isovalue = -3.1857e-13 # horse
vv, ff = measure.marching_cubes_classic(indicator_function, isovalue, spacing=(0.0072, 0.0072, 0.0072))
# vv, ff, _, _ = measure.marching_cubes_lewiner(indicator_function, isovalue)
vv /= indicator_function.shape[-1]
m = trimesh.Trimesh(vv, ff)
m.export("fox.ply")
