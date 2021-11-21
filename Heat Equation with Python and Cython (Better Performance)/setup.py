from distutils.core import setup
from Cython.Distutils import build_ext 
from distutils.extension import Extension
from Cython.Build import cythonize
import numpy

exts = (cythonize('heat_cyt01.pyx', language_level="3", annotate=True))

setup(ext_modules=exts,
	include_dirs=[numpy.get_include()])
