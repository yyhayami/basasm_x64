#pi4.py
import math
n = 32
a = 0
s = 1

for i in range(n):
    a = math.sqrt(1/2 + a/2) 
    s *= a

pi = 2 / s
print(pi)

