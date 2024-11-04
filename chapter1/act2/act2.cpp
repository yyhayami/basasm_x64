// act2.cpp : このファイルには 'main' 関数が含まれています。プログラム実行の開始と終了がそこで行われます。
//

#include <stdio.h>
extern "C" void asmCode2(long long* a, int b);

int main()
{
    long long  a;

    a = 199999999000;
    asmCode2(&a, 1123);
    printf("a = %lld\n", a);
}
