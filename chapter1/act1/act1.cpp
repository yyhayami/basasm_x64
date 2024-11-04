// act1.cpp : このファイルには 'main' 関数が含まれています。プログラム実行の開始と終了がそこで行われます。
//

#include <stdio.h>
extern "C" void asmCode(int* a, int b);

int main()
{
    int a;
    asmCode(&a, 123);
    printf("a = %d\n", a);
}
