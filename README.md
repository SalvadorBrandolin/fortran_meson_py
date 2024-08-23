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
  - [CI (`cibuildwheel`)](#ci-cibuildwheel)
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
We made a post of this topic in ```fortan-lang discussion```. Maybe you can
understand more the motivations of this repository. Also, you may find 
commentaries from other users that can help you.

[https://fortran-lang.discourse.group/t/packaging-a-fpm-project-with-python-bindings-a-little-guide-and-insights-from-our-experience/8495](https://fortran-lang.discourse.group/t/packaging-a-fpm-project-with-python-bindings-a-little-guide-and-insights-from-our-experience/8495)


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
definition of the `calculate_area` and `calculate_perimeter` subroutines. These
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
Is kind to have the c_wrapper separated from everything else, but of course you
can do whatever you want. The [c_wrapper](c_wrapper) directory contains the
necessary files to build the `C` wrapper of the Fortran library. The `C`
wrapper uses the `iso_c_binding` module to define subroutines compatible with
`C` types.

```
Well, so I have to rewrite all my subroutines compatible with C?
```

Well, yes... I'm sorry. This is a pain for sure but necessary. Of course, we
don't have to implement again the subroutines, only the subroutines signatures.
Inside we call our `fpm` library.

You can check the [fexample_c.f90](c_wrapper/fexample_c.f90) file. There are
defined the same functions as in `fexample` with addition of `*_c` in their
names to differentiate them. Also, we differentiate:

  - `fexample`: `fpm` project (`Fortran` library)
  - `fexample_c`: C-API of `fexample`

### Python API
The nightmare begins here (lots of commits till compiles).

In the case of `fexample` there is no big problems, but for a more complex
library with OOP architecture and lots of linking dependencies in compilations
will take some time to make it work.

`Fortran` users that are too used to `fpm` capabilities as I (Salvador) and
don't have much experience dealing with compilations flags, this is your first
challenge. 

> **Note 3 (Salvador)**: Really this is the true motivation of made this little
> example. To learn and mess around with a build system and compilations flags.
> In my `Fortran` language learning path I always used `fpm` and its was fun,
> its solves all the compilations for me. And for sure I don't want to solve
> the compilation order of any modern `Fortran` project, `fpm` already does.
> So, It's possible to compile `fexample` with `fpm`, and the link it with f2py
> and be happy? We found that meson allows us to do that, and all works pretty
> fine.

We are using `meson-python` as the build system for the Python library. For that you can check the configurations of:

- [python/meson.build](python/meson.build)
- [python/pyproject.toml](python/pyproject.toml)

As in any `Python` we provide a [requirements-dev.txt](python/requirements-dev.txt) file with dependencies for developing. But here, we also provided a [build-requirements.txt](python/build-requirements.txt) file with the dependencies for building the Python API. You can check that in the pyproject.toml and build-requirements.txt files the dependencies are the same.
Why we do that? Because, when developing the package the developer
need to install the `Python` package in `--editable` mode. With
`meson-python` it's necessary to manually install the build dependencies and then install the package in `--editable` mode.
The correct way of doing that is bay the commands:

```shell
cd python
pip install -r python/build-requirements.txt
pip install -e . --no-build-isolation
```

Then we have the [python/fexample](python/fexample) directory that contains the source code of the python library.

There we have the [python/fexample/compiled](python/fexample/compiled)
directory that contains the `C` wrapper of the `fexample` library. The `C`
wrapper is compiled with `f2py` and linked with the `fexample` library, and
finally, stored in that directory. You can check the meson.build configuration
file, on the `py.extension`, how that is done.

## Miscellaneous
### CI (`cibuildwheel`)
This is not really neccesary, buy maybe you want to distribute your python package with `PyPI`. Well, is the moment to obtain a compiled wheel matrix: 

```
WheelMatrix = OS you want to support times Python versions you want to support
```

On the [.github/workflows/wheels.yml](.github/workflows/wheels.yml) there is an
action that uses `cibuildwheel` to compile the wheels for the Python API. The
wheels are not uploaded to `PyPI`, but you can do that with the `twine`
package.

### For VScode users
.vscode settings are recommended to be used: 

[git@github.com:ipqa-research/vscode-fortran.git](git@github.com:ipqa-research/vscode-fortran.git)

There you can find the settings for the Fortran language compatible with `fpm`
