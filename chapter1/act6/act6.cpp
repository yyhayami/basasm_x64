// act6.cpp : このファイルには 'main' 関数が含まれています。プログラム実行の開始と終了がそこで行われます。
//

#include <stdio.h>
extern "C" long long asmCode5(long long a, long long b, long long* d);

int main()
{
    long long  a, b, c, d, pi;

    a = 355 * 1000000;
    b = 113;
    c = asmCode5(a, b, &d);
    pi = asmCode5(c, 1000000, &d);
    printf("pi = %lld.%lld", pi, d);
}
