// act5.cpp : このファイルには 'main' 関数が含まれています。プログラム実行の開始と終了がそこで行われます。
//

#include <stdio.h>
extern "C" long long asmCode5(long long a, long long b, long long* d);

int main()
{
    long long  a, b, c, d;

    a = 66666666660032;
    b = 6;
    c = asmCode5(a, b, &d);
    printf("c = %lld\nd = %lld\n", c, d);
}
