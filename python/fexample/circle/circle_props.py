from fexample.compiled import fexample_c as fc


def calculate_area(radius):
    return fc.calculate_area_c(radius)


def calculate_perimeter(radius):
    return fc.calculate_perimeter_c(radius)