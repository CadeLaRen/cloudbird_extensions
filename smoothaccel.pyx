__all__ = ("SmoothAccelerometer")

from libc.math cimport log
import warnings

cdef class SmoothAccelerometer(object):
    #weights = [.05, .1, .1, .4, .5]
    cdef list w
    cdef list weights
    cdef list last_accels
    cdef bint enabled
    cdef object accel
    cdef object __weakref__

    property acceleration:
        def __get__(self):
            cdef int i
            cdef double weight, value
            cdef list a, acc

            if not self.enabled:
                warnings.warn("Accelerometer is not enabled!", UserWarning, stacklevel=2)
            self.last_accels.pop(0)
            self.last_accels.append(self.accel.acceleration)
            acc = []
            for i from 0 <= i < len(self.last_accels[0]):
                a = []
                for la in self.last_accels:
                    a.append(la[i])
                acc.append(sum([weight * value for weight, value in zip(self.weights, a)]))
            return acc

    def __cinit__(self):
        cdef int x

        self.w = [log(x) for x from 5 <= x < 45]
        self.weights = [x/sum(self.w) for x in self.w]
        self.last_accels = []
        self.enabled = False

    def __init__(self, accel):
        self.accel = accel

    cdef void _enable(SmoothAccelerometer self):
        cdef int i

        self.enabled = True
        self.accel.enable()
        self.last_accels = []

        for i from 0 <= i < 40:
            self.last_accels.append(self.accel.acceleration)

    def enable(self, *args):
        self._enable()

    def disable(self, *args):
        self.enabled = False
        self.accel.disable()
