module {{cookiecutter.project_name}}_c
   use {{cookiecutter.project_name}}, only: say_hello
   implicit none

contains
   subroutine say_hello_c()     
      call say_hello()
   end subroutine say_hello_c
end module {{cookiecutter.project_name}}_c
