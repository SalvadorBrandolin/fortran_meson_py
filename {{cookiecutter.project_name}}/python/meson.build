project('{{cookiecutter.project_name}}', 'c',
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


# fpm
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

# f2py
source_path = meson.source_root() / '..' / 'c_wrapper' / '{{cookiecutter.project_name}}_c.f90'
{{cookiecutter.project_name}}_c_f90 = files(source_path)

{{cookiecutter.project_name}}_source = custom_target('{{cookiecutter.project_name}}_compiled.c',
  input: {{cookiecutter.project_name}}_c_f90,
  output: ['{{cookiecutter.project_name}}_compiledmodule.c', '{{cookiecutter.project_name}}_compiled-f2pywrappers2.f90'],
  command: [
    py,
    '-m',
    'numpy.f2py',
    '@INPUT@',
    '-m',
    '{{cookiecutter.project_name}}_compiled',
    '--lower'
  ]
)

# Install Python sources
f_sources = ['{{cookiecutter.project_name}}/compiled/__init__.py']
py.install_sources(f_sources, subdir:'{{cookiecutter.project_name}}/compiled')

main_sources = ['{{cookiecutter.project_name}}/__init__.py', '{{cookiecutter.project_name}}/main.py']
py.install_sources(main_sources, subdir:'{{cookiecutter.project_name}}')

# Extension fortran module
inc_np = include_directories(incdir_numpy, incdir_f2py, 'fpm_build' / 'include')

py.extension_module('{{cookiecutter.project_name}}_compiled',
  [{{cookiecutter.project_name}}_c_f90, {{cookiecutter.project_name}}_source],
  incdir_f2py / 'fortranobject.c',
  include_directories: [inc_np],
  dependencies : py_dep,
  link_args: ['-L' + 'fpm_build' / 'lib', '-l{{cookiecutter.project_name}}'],
  subdir: '{{cookiecutter.project_name}}' / 'compiled',
  install : true,
)
