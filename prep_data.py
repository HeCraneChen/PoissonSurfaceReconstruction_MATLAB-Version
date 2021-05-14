
import trimesh
import numpy as np

def getCoorNormal(path, nsamp = 25000):
    mesh = trimesh.load(path)
    v, fid = trimesh.sample.sample_surface(mesh, count=int(nsamp))
    v = v[:nsamp]               # vertex coordinates
    fid = fid[:nsamp]
    n = mesh.face_normals[fid]  # vertex normals
    return v, n

path = "fox.ply"
v, n = getCoorNormal(path, 25000)
vn = np.concatenate((v,n),1)
np.savetxt( "fox.txt", vn)