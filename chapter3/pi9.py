#pi9.py
from decimal import *

kp = 71
ki = 21
s = Decimal(0)

def CalcSp():
    global s
    a = Decimal(80)
    for i in range(1,kp+1):
        u = Decimal(i * 2 - 1)
        a /= Decimal(25)
        b = a
        b /= u
        if (i % 2)==1:
            s = s + b
        else:
            s = s - b

def CalcSi():
    global s
    a = Decimal(956)
    for i in range(1,ki+1):
        u = i * 2 - 1
        a /=  57121
        b = a
        b /= u
        if (i % 2)==0:
            s = s + b
        else:
            s = s - b

getcontext().prec = 100
CalcSp()
CalcSi()
print(s)

