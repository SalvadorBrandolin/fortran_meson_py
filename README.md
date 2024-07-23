# fortran_meson_py
## About the repository
Example of building python API of Fortran project with Meson. The idea is to 
have an example of a Fortran library that runs with 
[fpm](https://github.com/fortran-lang/fpm) and a Python API inside the same
repository. The idea is to compile the Fortran code with fpm and then use meson
to compile the `C` wrapper of the library with numpy.f2py (using the fpm 
compilation as link library). Finally, construct different build of the Python
API for different python versions and OS.

## For VScode users
.vscode is recommended to be used: 

git@github.com:ipqa-research/vscode-fortran.git
