#pi5.py
import math
n = 23
a = 1
b = 1

for i in range(1, n):
    b = b * i * i /((2 * i + 1) * (2 * i + 2))
    a += b

pi = math.sqrt(a * 9)
print(pi)

