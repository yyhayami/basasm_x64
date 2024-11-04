// act4.cpp : このファイルには 'main' 関数が含まれています。プログラム実行の開始と終了がそこで行われます。
//
#include <stdio.h>
extern "C" long long asmCode4(long long a, long long b);

int main()
{
    long long  a, b, c;

    a = 11111111100123;
    b = 3;
    c = asmCode4(a, b);
    printf("c = %lld\n", c);
}

