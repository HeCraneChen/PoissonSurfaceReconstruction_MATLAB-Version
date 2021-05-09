
import trimesh
from skimage import measure
import scipy
from scipy import io

data = scipy.io.loadmat('indicator_function.mat')
indicator_function = data['output'] * (-1)
vv, ff, _, _ = measure.marching_cubes_lewiner(indicator_function, 0)
vv /= indicator_function.shape[-1]
m = trimesh.Trimesh(vv, ff)
m.export("fox.ply")
