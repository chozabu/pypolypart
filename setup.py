from os import environ
from os.path import dirname, join
from distutils.core import setup
from distutils.extension import Extension
try:
    from Cython.Distutils import build_ext
    have_cython = True
except ImportError:
    have_cython = False

c_polypart_root = join(dirname(__file__), 'pypolypart', 'polypartition')
c_polypart_src = join(c_polypart_root, 'src')
c_polypart_incs = [c_polypart_src]
c_polypart_files = [join(c_polypart_src, x) for x in [
    'polypartition.cpp']]

if have_cython:
    pypolypart_files = [
        'pypolypart/python/pypolypart.pyx'
        ]
    cmdclass = {'build_ext': build_ext}
else:
    pypolypart_files = ['pypolypart/python/pypolypart.c']
    cmdclass = {}
    
ext = Extension('pypolypart',
    pypolypart_files + c_polypart_files,
    include_dirs=c_polypart_incs,
    language="c++")
 

if environ.get('READTHEDOCS', None) == 'True':
    ext.pyrex_directives = {'embedsignature': True}

setup(
    name='pypolypart',
    description='Cython bindings for Polygon Partition',
    author='Alex Chozabu PB - refrencing cymunk',
    author_email='chozabu@gmail.com',
    cmdclass=cmdclass,
    ext_modules=[ext])
