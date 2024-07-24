project('fexample', 'c',
  version : '0.1.0',
  license: 'MIT',
  meson_version: '>=0.64.0',
  default_options : ['warning_level=2'],
)

add_languages('fortran')

meson_path = meson.current_build_dir()

py_mod = import('python')
py = py_mod.find_installation(pure: false)
py_dep = py.dependency()


incdir_numpy = run_command(py,
  ['-c', 'import os; os.chdir('.."); import numpy; print(numpy.get_include())'],
  check : true
).stdout().strip()


incdir_f2py = run_command(py,
    ['-c', 'import os; os.chdir(".."); import numpy.f2py; print(numpy.f2py.get_include())'],
    check : true
).stdout().strip()


inc_np = include_directories(incdir_numpy, incdir_f2py)


# fpm?
fflags = '-g -fPIC -funroll-loops -fstack-arrays -Ofast -frepack-arrays -faggressive-function-elimination -fopenmp'
cflags = '-fPIC'
fpm_build_dir = meson_path / 'build' / 'python'

run_command(
    'fpm',
    'install',
    '--profile',
    'release',
    '--flag',
    fflags,
    '--c-flag',
    cflags,
    '--prefix',
    fpm_build_dir,
)

# f2py?
potential_source = custom_target('potentialmodule.c',
  input : ['galaxychop/preproc/fortran/potential.f90'],
  output : [
    'potentialmodule.c', 
    'potential-f2pywrappers2.f90'
    ],
  command : [
    py, '-m', 'numpy.f2py', '@INPUT@', 
    '-m', 'potential', '--lower'
  ]
)

f_sources = ['galaxychop/preproc/fortran/__init__.py']
py.install_sources(f_sources, subdir:'galaxychop/preproc/fortran')


py.extension_module('fib2',
  [
    'fib1.f',
    'fib2module.c',  # note: this assumes f2py was manually run before!
  ],
  incdir_f2py / 'fortranobject.c',
  include_directories: inc_np,
  dependencies : py_dep,
  install : true
)