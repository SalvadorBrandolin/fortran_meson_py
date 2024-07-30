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
  ['-c', 'import os; os.chdir(".."); import numpy; print(numpy.get_include())'],
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
fpm_build_dir = meson_path / 'fpm_build'

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
    check : true
)

# f2py?
source_path = meson_path / '..' / '..' / '..' / 'c_wrapper' / 'fexample_c.f90'
library_path = fpm_build_dir / 'lib'
include_path = fpm_build_dir / 'include'

fexample_source = custom_target('fexample.c',
  input: [source_path, library_path, include_path],
  output: ['fexample.c', 'fexample-f2pywrappers2.f90'],
  command: [
    py,
    '-m',
    'numpy.f2py',
    '-m',
    'fexample',
    '-c',
    '-L' + '@INPUT1@',
    '-I' + '@INPUT2@',
    '@INPUT0@',
    '-lfexample',
    '--lower'
  ]
)

py.extension_module('fexample',
  [source_path, fexample_source],
  incdir_f2py / 'fortranobject.c',
  include_directories: inc_np,
  dependencies : py_dep,
  install : true,
  subdir: 'fexample/compiled/'
)

