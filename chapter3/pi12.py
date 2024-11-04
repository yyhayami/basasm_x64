#pi12.py
import sympy
import time

start = time.time()
s = str(sympy.pi.evalf(10002))
elapsed_time = time.time() - start
print(s[:2], end=" ")

for i in range(2,10001)[::100]:
    if (i % 1000)==2:
        print(" ")
    print(s[i:i + 100])

print("")
print("計算時間:{:.6f}".format(elapsed_time) + "[sec]")

