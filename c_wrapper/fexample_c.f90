module fexample_c
   use iso_c_binding, only: c_double
   use fexample, only: calculate_area, calculate_perimeter

contains
   subroutine calculate_area_c(radius, area)
      real(c_double), intent(in) :: radius
      real(c_double), intent(out) :: area

      call calculate_area(radius, area)
   end subroutine calculate_area_c

   subroutine calculate_perimeter_c(radius, perimeter)
      real(c_double), intent(in) :: radius
      real(c_double), intent(out) :: perimeter

      call calculate_perimeter(radius, perimeter)
   end subroutine calculate_perimeter_c
end module fexample_c
