"""Little test to check that the wheels are builded correctly

pytest is chosen as the testing framework.
"""
from fexample import circle

import numpy as np


def test_circle():
    # Area
    assert abs(circle.calculate_area(4.6) - 66.47610054996001) < 1e-6
    assert abs(circle.calculate_area(1.0) - np.pi) < 1e-6
    assert abs(circle.calculate_area(0.0) - 0.0) < 1e-6

    # Perimeter
    assert abs(circle.calculate_perimeter(5.3) - 33.3008821280518) < 1e-6
    assert abs(circle.calculate_perimeter(1.0) - 2 * np.pi) < 1e-6
    assert abs(circle.calculate_perimeter(0.0) - 0.0) < 1e-6
