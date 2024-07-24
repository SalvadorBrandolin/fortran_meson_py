module fexample_circle_props
   !! Circle properties module
   use fexample_constants, only: pr, pi
   implicit none

contains
   subroutine calculate_area(radius, area)
      real(pr), intent(in) :: radius
      real(pr), intent(out) :: area

      area = pi * radius**2
   end subroutine calculate_area

   subroutine calculate_perimeter(radius, perimeter)
      real(pr), intent(in) :: radius
      real(pr), intent(out) :: perimeter

      perimeter = 2.0_pr * pi * radius
   end subroutine calculate_perimeter
end module fexample_circle_props
