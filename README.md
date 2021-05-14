# PoissonSurfaceReconstruction_MATLAB-Version

This repo includes Poisson Surface Reconstruction code in MATLAB mostly. For the MarchingCubes function, we used Python skimage package.

# Usage
Download data from the following link, Unzip it into the code folder, so that all data should be stored in"PoissonSurfaceReconstruction_MATLAB-Version/Data", and the code should run, no other changes required.

https://drive.google.com/drive/folders/1kKZinGw09bzwPw-0wMcZhhJJJDEZAMEu?usp=sharing

# Requirements
For Matlab code, Matlab2019A or whatever version.

For Marching Cubes, Visualization, and Uniformly sampling oriented points from a PLY file, need to create a Conda environment or Virtual environment of Python3 and install the following libraries.

Numpy

Scipy

Skimage

Trimesh

Open3D


# Some Results in 2D

Direct (run ElephantSolver.m) --res 128 

![Elephant_Direct](https://user-images.githubusercontent.com/33951209/118314648-441a9e80-b4a9-11eb-8a5c-9facee7713b0.jpg)

Jacobi (run IterativeElephantSolver.m) --res 128 --iter 100 

![Elephant_Jacobi](https://user-images.githubusercontent.com/33951209/118314707-5a285f00-b4a9-11eb-8cad-3a0bdd397b08.jpg)

Gauss-Seidel (run IterativeElephantSolver.m) --res 128 --iter 100 

![Elephant_GaussSeidel](https://user-images.githubusercontent.com/33951209/118314722-5e547c80-b4a9-11eb-8ed1-23798654f402.jpg)

Multigrid (run IterativeElephantSolver.m) --res 128 --iter 10

![Elephant_Multigrid](https://user-images.githubusercontent.com/33951209/118314731-614f6d00-b4a9-11eb-901b-0e36b06052f9.jpg)

Ground truth grid
![gt_grid](https://user-images.githubusercontent.com/33951209/118325601-8c8d8880-b4b8-11eb-80d0-9e194c620c38.jpg)

Numerical Error (gt_grid - output)

![num_error](https://user-images.githubusercontent.com/33951209/118325677-a4650c80-b4b8-11eb-8e9a-4c3446f55c9e.jpg)


# Some Results in 3D (Slices)

# Some Results in 3D (The surface after marching cubes)

