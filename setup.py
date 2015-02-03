from distutils.core import setup
from Cython.Build import cythonize

setup(
    name = "CloudBird Extensions",
    ext_modules = cythonize('*.pyx'),  # accepts a glob pattern
)