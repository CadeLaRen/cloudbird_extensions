from distutils.core import setup
from distutils.extension import Extension

setup(
    name = "CloudBird Extensions",
    ext_modules = [Extension("cloudbird_extensions", ["polygon.c", "smoothaccel.c"])],
)