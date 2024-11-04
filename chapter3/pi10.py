#pi10.py
import time
ke = 1002
kp = 7160
ki = 2105
d = 10000000000
a = [0] * ke
b = [0] * ke
s = [0] * ke

def CalcSp():
    a[0] = 80
    for i in range(1,kp+1):
        u = i * 2 -1
        LongDiv(a, 25)
        LongTo()
        LongDiv(b ,u)
        if (i % 2)==1:
            LongAdd()
        else:
            LongSub()

def CalcSi():
    a[0] = 956
    for i in range(1,ki+1):
        u = i * 2 -1
        LongDiv(a, 57121)
        LongTo()
        LongDiv(b ,u)
        if (i % 2)==0:
            LongAdd()
        else:
            LongSub()

def LongTo():
    for i in range(ke):
        b[i] = a[i]

def LongAdd():
    c = 0
    for i in range(0,ke)[::-1]:
        s[i] = s[i] + b[i] + c
        if s[i] >= d:
            s[i] -= d
            c = 1
        else:
            c = 0

def LongSub():
    c = 0
    for i in range(0,ke)[::-1]:
        s[i] = s[i] - b[i] - c
        if s[i] < 0:
            s[i] += d
            c = 1
        else:
            c = 0

def LongDiv(x, t):
    for i in range(ke-1):
        m = x[i] // t
        n = x[i] % t
        x[i] = m
        x[i+1] += n * d
    x[ke-1] = x[ke-1] // t

def PrintS():
    print(s[0],end=".")
    print(" ")
    for i in range(1,ke-1):
        print('{:0=10}'.format(s[i]),end=" ")
        if (i % 10) == 0:
            print(" ")
            if (i % 100) == 0:
                print(" ")

start = time.time()
CalcSp()
CalcSi()
elapsed_time = time.time() - start
PrintS()
print("")
print("Elapsed time:{:.6f}".format(elapsed_time) + "[sec]")

