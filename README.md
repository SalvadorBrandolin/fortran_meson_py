# fortran_meson_py

## Table of contents
- [About the repository](#about-the-repository)
- [Previous lectures (if needed)](#previous-lectures-if-needed)
  - [Fortran](#fortran)
  - [Python](#python)
  - [Meson](#meson)
- [Library directory structure](#library-directory-structure)
  - [Fortran library (fpm)](#fortran-library-fpm)
  - [`C` Wrapper](#c-wrapper)
  - [Python API](#python-api)
- [Miscellaneous](#miscellaneous)
  - [For VScode users](#for-vscode-users)


## About the repository
Example of building Python API of Fortran project with Meson. 

The objective is to demonstrate how to integrate a Fortran library that runs
with the Fortran Package Manager ([fpm](https://github.com/fortran-lang/fpm))
and a Python API within the same repository, enabling package building and
distribution.

The idea is having an example of a Fortran library that runs with
[fpm](https://github.com/fortran-lang/fpm) and a Python API inside the same
repository that builds and distributes the package. 

First, the Fortran project is compiled with fpm. Then, the Meson build system
is used to compile the `C` wrapper for the Fortran library using numpy.f2py,
linking with the fpm-compiled library. Finally, the repository builds different
Python API wheels for various Python versions and operating systems.

Apologies in advance for experienced users, the repository is intended for
beginners in the field of Fortran, Python, and Meson. And useful to simple
architectures of Fortran code. It is assumed that an experienced user will be
capable to adapt the repository to more complex cases. 

## Previous lectures (if needed)
### Fortran
Little knowledge of Fortran is needed. It's necessary to know how to install a
Fortran compiler (`gfortran` is used in this example) and the Fortran Package
Manager (fpm). The following links can be useful:

- Learn Fortran: https://fortran-lang.org/learn/
- fpm: https://fpm.fortran-lang.org/
- Compiler and IDE: https://fortran-lang.org/learn/os_setup/


### Python
Little knowledge of Python is needed. It's necessary to know how to install
Python on your system, and preferably, how to use virtual environments.

- Learn and install Python: https://wiki.python.org/moin/BeginnersGuide
- Virtual environments: https://virtualenv.pypa.io/en/latest/
- Numpy f2py meson: https://numpy.org/doc/stable/f2py/buildtools/meson.html 
- Interesting to know: https://virtualenvwrapper.readthedocs.io/en/latest/


### Meson
Meson build system lectures and specific sections of the documentation are
provided:

- Meson tutorial: https://mesonbuild.com/Tutorial.html
- Meson py.extesion: https://mesonbuild.com/Python-module.html#extension_module
- meson-python: https://mesonbuild.com/meson-python/


## Library directory structure
### Fortran library (fpm)
If you are familiar with `fpm` and you have a Fortran project that you want to
have a Python API, your project should look something like this:

```
├── app
│   └── main.f90
├── src
│   ├── circle
│   │   └── circle_props.f90
│   ├── constants.f90
│   └── fexample.f90
├── test
│    └── check.f90
├── LICENSE
├── fpm.toml
└── README.md
```

This is normally the structure of any new `fpm` project.

```bash
fpm new <project name>
```

For this tutorial the [app](app) and [test](test) directories are not of our
interest. First, we focus on the [fpm.toml](fpm.toml) file. There are all the
configurations of the Fortran project. Here it's important to set the `library`
setting to `true`:

```toml
[install]
library = true
```

Is necessary like that to generate the necessary files to build the Python API
by linking the `fpm` compilation. Also, you can observe that our library's name
is `fexample`.

Next, in the [src](src) directory, we have the Fortran source code of the
library. The [constants.f90](src/constants.f90) file contains the definition of
the constant `pi` and the parameter `pr` (the precision of the float numbers in
our project).

Then, the [fexample.f90](src/fexample.f90) file contains the definition of the
main module of the library, called the same as the library. There we only
import all the modules of the library.

Finally, the [circle_props.f90](src/circle/circle_props.f90) file contains the
definition of the `circle_area` and `circle_circumference` subroutines. These
subroutines are used to calculate the area and circumference of a circle, with
a given radius. Those are the subroutines that we want to use in our Python
API.

Of course, the example is very simple, but it's enough to demonstrate the idea.
Just imagine that those subroutines have a very complex and expensive
calculation...

> **Note 1**: Check the definition of the subroutines, you must explicitly
> define the `intent` of the variables.

> **Note 2**: I told you that the [app](app) directory is not of our interest,
> but you can perform the `fpm run` command to test the two subroutines if you
> want.

### `C` Wrapper


### Python API

## Miscellaneous
### For VScode users
.vscode settings are recommended to be used: 

[git@github.com:ipqa-research/vscode-fortran.git](git@github.com:ipqa-research/vscode-fortran.git)

There you can find the settings for the Fortran language compatible with `fpm`
