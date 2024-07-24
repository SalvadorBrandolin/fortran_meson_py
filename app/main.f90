program main
   use fexample, only: pr, calculate_area, calculate_perimeter
   implicit none

   real(pr) :: area, perimeter
   real(pr) :: radius = 3.0_pr

   call calculate_area(radius, area)
   call  calculate_perimeter(radius, perimeter)

   print *, "Circle radius: ", radius
   print *, "Circle area: ", area
   print *, "Circle perimeter: ", perimeter
end program main
