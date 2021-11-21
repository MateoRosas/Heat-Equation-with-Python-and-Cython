#cython: language_level=3

import numpy as np
cimport numpy as cnp
cimport cython

import matplotlib
matplotlib.use('Agg')

import matplotlib.pyplot as plt

cdef extern from "math.h":
    double pow(double x, double y) nogil

# Set the colormap
plt.rcParams['image.cmap'] = 'BrBG'


ctypedef cnp.double_t DTYPE_t


@cython.cdivision(True)
cdef void evolve(cnp.ndarray[DTYPE_t, ndim=2] u, cnp.ndarray[DTYPE_t, ndim=2] u_previous,double a,double dt, double dx2, double dy2):
    """Explicit time evolution.
       u:            new temperature field
       u_previous:   previous field
       a:            diffusion constant
       dt:           time step. """
    cdef int i, j, m, n

    cdef cnp.ndarray[DTYPE_t, ndim=2] ci
    
    n = u.shape[1]
    m = u.shape[0]
    

    for i in range(1, n-1):
        for j in range(1, m-1):
            u[i, j] = u_previous[i, j] + a * dt * ( \
             (u_previous[i+1, j] - 2*u_previous[i, j] + \
              u_previous[i-1, j]) / dx2 + \
             (u_previous[i, j+1] - 2*u_previous[i, j] + \
                 u_previous[i, j-1]) / dy2 )

    u_previous[:] = u[:]

@cython.boundscheck(False)
@cython.wraparound(False)
@cython.cdivision(True)
def iterate(cnp.ndarray[DTYPE_t, ndim=2] field, cnp.ndarray[DTYPE_t, ndim=2] field0, double a, double dx, double dy, int timesteps, image_interval):
    """Run fixed number of time steps of heat equation"""
    cdef double dx2, dy2, dt
    cdef int m
    dx2 = pow(dx, 2)
    dy2 = pow(dy, 2)

    # For stability, this is the largest interval possible
    # for the size of the time-step:
    dt = dx2*dy2 / ( 2*a*(dx2+dy2) )    

    for m in range(1, timesteps+1):
        evolve(field, field0, a, dt, dx2, dy2)
        if m % image_interval == 0:
            write_field(field, m)


def init_fields(str filename):
    # Read the initial temperature field from file
    cdef cnp.ndarray[DTYPE_t, ndim=2] field, field0
    field = np.loadtxt(filename)
    field0 = field.copy() # Array for field of previous time step
    return field, field0


def write_field(cnp.ndarray[DTYPE_t, ndim=2] field, step):
    plt.gca().clear()
    plt.imshow(field)
    plt.axis('off')
    plt.savefig('heat_{0:03d}.png'.format(step))


