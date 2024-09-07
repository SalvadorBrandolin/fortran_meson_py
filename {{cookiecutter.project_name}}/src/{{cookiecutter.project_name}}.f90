module {{cookiecutter.project_name}}
   implicit none
   private

   public :: say_hello
contains
   subroutine say_hello
      print *, "Hello, {{cookiecutter.project_name}}!"
   end subroutine say_hello
end module {{cookiecutter.project_name}}
