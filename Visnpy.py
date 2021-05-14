import numpy as np
import open3d as o3d



pointcloud = np.loadtxt('fox.txt')
# print(pointcloud.shape) #(10000, 4)

coor = pointcloud[:,:3]
normal = pointcloud[:,3:]
dummy = np.zeros((coor.shape[0],1))

# print(pointcloud.shape)
print("coor.shape", coor.shape)
print("normal.shape", normal.shape)
pcd = o3d.geometry.PointCloud()
pcd.points = o3d.utility.Vector3dVector(coor)
pcd.normals = o3d.utility.Vector3dVector(normal)
o3d.visualization.draw_geometries([pcd])