#pi8.py
kp = 11
ki = 3
s = 0

def CalcSp():
    global s
    a = 80
    for i in range(1,kp+1):
        u = i * 2 - 1
        a /= 25
        b = a
        b /= u
        if (i % 2)==1:
            s += b
        else:
            s -= b

def CalcSi():
    global s
    a = 956
    for i in range(1,ki+1):
        u = i * 2 - 1
        a /=  57121
        b = a
        b /= u
        if (i % 2)==0:
            s += b
        else:
            s -= b

CalcSp()
CalcSi()
print(s)


