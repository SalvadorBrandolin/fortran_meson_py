module fexample_constants
   !! Constants module
   use iso_fortran_env, only: real64
   implicit none

   integer, parameter :: pr = real64
   real(pr) :: pi = 3.141592653589793_pr
end module fexample_constants
