"""
Collection of linear algebra operations and CG solver
"""
from mpi4py import MPI
import numpy as np
from . import data
from . import operators


def hpc_dot(x, y):
    """Computes the inner product of x and y"""
    
    # For loop implementation
    #prod = 0.0
    #for i in range(0, x.domain.nloc):
    #    prod += x.inner[i]*y.inner[i]
    #result = np.zeros(1)
    #comm = x.domain.comm
    #comm.Allreduce(prod, result, op=MPI.SUM)
    #return result
    
    prod = np.multiply(x.inner, y.inner).sum()
    result = np.zeros(1)
    x.domain.comm.Allreduce(np.array(prod), result, op=MPI.SUM)
    return result[0]


def hpc_norm2(x):
    """Computes the 2-norm of x"""
    
    return np.sqrt(hpc_dot(x, x))


class hpc_cg:
    """Conjugate gradient solver class: solve the linear system A x = b"""
    def __init__(self, domain):
        self._Ap = data.Field(domain)
        self._r  = data.Field(domain)
        self._p  = data.Field(domain)

        self._v  = data.Field(domain)
        self._Fx = data.Field(domain)

    def solve(self, A, b, x, tol, maxiter):
        """Solve the linear system A x = b"""
        # initialize
        A(x, self._Ap)
        self._r.inner[...] = b.inner[...] - self._Ap.inner[...]
        self._p.inner[...] = self._r.inner[...]
        delta_kp = hpc_dot(self._r, self._r)
 
        # iterate
        converged = False
        for k in range(0, maxiter):
            delta_k = delta_kp
            if delta_k < tol**2:
                converged = True
                break
            A(self._p, self._Ap)
            alpha = delta_k/hpc_dot(self._p, self._Ap)
            x.inner[...] += alpha*self._p.inner[...]
            self._r.inner[...] -= alpha*self._Ap.inner[...]
            delta_kp = hpc_dot(self._r, self._r)
            self._p.inner[...] = ( self._r.inner[...]
                                  + delta_kp/delta_k*self._p.inner[...] )

        return converged, k + 1
