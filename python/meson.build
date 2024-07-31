project('fexample', 'c',
  version : '0.1.0',
  license: 'MIT',
  meson_version: '>=0.64.0',
  default_options : ['warning_level=2'],
)

add_languages('fortran', native: false)

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
source_path = meson.source_root() / '..' / 'c_wrapper' / 'fexample_c.f90'
fexample_c_f90 = files(source_path)

fexample_source = custom_target('fexample_compiled.c',
  input: fexample_c_f90,
  output: ['fexample_compiledmodule.c', 'fexample_compiled-f2pywrappers2.f90'],
  command: [
    py,
    '-m',
    'numpy.f2py',
    '@INPUT@',
    '-m',
    'fexample_compiled',
    '--lower'
  ]
)

# Install Python sources
f_sources = ['fexample/compiled/__init__.py']
py.install_sources(f_sources, subdir:'fexample/compiled')

main_sources = ['fexample/__init__.py']
py.install_sources(main_sources, subdir:'fexample')

circle_sources = [
  'fexample/circle/__init__.py',
  'fexample/circle/circle_props.py',
]
py.install_sources(circle_sources, subdir:'fexample/circle')


# Extension fortran module
inc_np = include_directories(incdir_numpy, incdir_f2py, 'fpm_build' / 'include')

py.extension_module('fexample_compiled',
  [fexample_c_f90, fexample_source],
  incdir_f2py / 'fortranobject.c',
  include_directories: [inc_np],
  dependencies : py_dep,
  link_args: ['-L' + 'fpm_build' / 'lib', '-lfexample'],
  subdir: 'fexample' / 'compiled',
  install : true,
)

