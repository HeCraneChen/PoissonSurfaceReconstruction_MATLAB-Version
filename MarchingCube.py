#  Authors: He "Crane" Chen, Misha Kazhdan
#  hchen136@jhu.edu
#  Johns Hopkins University, 2021

import trimesh
from skimage import measure
import scipy
from scipy import io

data = scipy.io.loadmat('./Data/indicator_function.mat')
indicator_function = data['output'] * (-1)
vv, ff, _, _ = measure.marching_cubes_lewiner(indicator_function, 0)
vv /= indicator_function.shape[-1]
m = trimesh.Trimesh(vv, ff)
m.export("./Results/fox_result.ply")
