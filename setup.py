from distutils.core import setup
from distutils.extension import Extension

setup(
    name = "CloudBird Extensions",
    ext_modules = [Extension("polygon", ["polygon.c"]), Extension("smoothaccel", ["smoothaccel.c"])],
)