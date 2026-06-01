from functools import wraps
from time import perf_counter

def count_lines(file):   
    """
    Count the number of lines in a file
    """
    with open(file) as f:
        return sum(1 for _ in f)

def timer(func):
    """
    Decorator to measure execution time of a function.
    """

    @wraps(func)
    def wrapper(*args, **kwargs):
        start = perf_counter()

        result = func(*args, **kwargs)

        end = perf_counter()

        print(f"{func.__name__} completed in {end - start:.2f} seconds")

        return result

    return wrapper