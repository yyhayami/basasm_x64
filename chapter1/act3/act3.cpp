// act3.cpp : このファイルには 'main' 関数が含まれています。プログラム実行の開始と終了がそこで行われます。
//

#include <stdio.h>
extern "C" long long asmCode3(long long a, long long b);

int main()
{
    long long  a,b,c;

    a = 1234567890123;
    b = 123;
    c = asmCode3(a, b);
    printf("c = %lld\n", c);
}
