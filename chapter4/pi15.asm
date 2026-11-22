;pi15.asm  円周率 100000桁版（2コア並列計算）
BITS 64
DEFAULT REL

GLOBAL main

EXTERN WriteFile
EXTERN GetStdHandle
EXTERN ExitProcess
EXTERN GetTickCount
EXTERN CreateThread
EXTERN WaitForMultipleObjects
EXTERN CloseHandle

STD_OUTPUT_HANDLE   equ  -11
INFINITE	equ  0FFFFFFFFh
maxNum  equ  1000000000
nKeta   equ  11122
nKp	equ  71610
nKi	equ  21045

SECTION .data

strData times 20 db  0
strLen  equ $-strData
	db  0
strData2 times 20 db  0
strLen2  equ $-strData2
	db  0
strPt	db  '.', 13,10,0
strS	db  's',0
strMs	db  'ms', 13,10,0
strCr	db  13,10,0
strEt	db  'Elapsed time = ',0

hOut    dq  0
numLen  dq  0
sTime	dd  0
eTime	dd  0
msTime	dd  0

hThread	dq  0, 0			; スレッドのハンドル2個

SECTION .bss

sNum   	resq nKeta		; 16×arctan(1/5) の和 → 最後に円周率
aNum   	resq nKeta		; 1/5 側の作業領域
bNum   	resq nKeta
sNumI  	resq nKeta		; 4×arctan(1/239) の和
aNumI  	resq nKeta		; 1/239 側の作業領域
bNumI  	resq nKeta

SECTION .text

; ---------------------------------------------------------------
; スレッド1：16×arctan(1/5) を sNum に求める
;   使用領域 r12 = aNum, r13 = bNum, r14 = sNum
; ---------------------------------------------------------------
threadSp:
	call	pushRegs
	lea	r12, [aNum]
	lea	r13, [bNum]
	lea	r14, [sNum]
	mov	qword [r12], 80
	mov	r9, 1
.loop1:
	mov	r8, 25
	mov	rdi, r12
	call	longDiv
	call	longTo
	mov	r8, r9
	shl	r8, 1
	dec	r8
	mov	rdi, r13
	call	longDiv
	test	r9, 1
	jz	.label1
	call	longAdd
	jmp	.label2
.label1:
	call	longSub
.label2:
	inc	r9
	cmp	r9, nKp
	jbe	.loop1
	call	popRegs
	xor	eax, eax			; スレッドの戻り値 0
	ret

; ---------------------------------------------------------------
; スレッド2：4×arctan(1/239) を sNumI に求める（正の値として足し込む）
;   使用領域 r12 = aNumI, r13 = bNumI, r14 = sNumI
; ---------------------------------------------------------------
threadSi:
	call	pushRegs
	lea	r12, [aNumI]
	lea	r13, [bNumI]
	lea	r14, [sNumI]
	mov	qword [r12], 956
	mov	r9, 1
.loop1:
	mov	r8, 57121
	mov	rdi, r12
	call	longDiv
	call	longTo
	mov	r8, r9
	shl	r8, 1
	dec	r8
	mov	rdi, r13
	call	longDiv
	test	r9, 1
	jz	.label1
	call	longAdd
	jmp	.label2
.label1:
	call	longSub
.label2:
	inc	r9
	cmp	r9, nKi
	jbe	.loop1
	call	popRegs
	xor	eax, eax
	ret

; Windows x64 で呼び出し先が保存すべきレジスタの退避・復帰
pushRegs:
	pop	rax			; 戻り番地
	push	rbx
	push	rsi
	push	rdi
	push	r12
	push	r13
	push	r14
	jmp	rax
popRegs:
	pop	rax
	pop	r14
	pop	r13
	pop	r12
	pop	rdi
	pop	rsi
	pop	rbx
	jmp	rax

main:
	call    initPro

	call	getTime
	mov	[sTime], eax

	sub	rsp, 38h		; シャドウスペース＋引数5,6（16バイト境界に揃える）

	xor	ecx, ecx		; 1: セキュリティ属性 NULL
	xor	edx, edx		; 2: スタックサイズ 既定
	lea	r8, [threadSp]		; 3: スレッド関数
	xor	r9d, r9d		; 4: 引数 NULL
	mov	qword [rsp+20h], 0	; 5: 作成フラグ 0（すぐ実行）
	mov	qword [rsp+28h], 0	; 6: スレッドID 不要
	call	CreateThread
	mov	[hThread], rax

	xor	ecx, ecx
	xor	edx, edx
	lea	r8, [threadSi]
	xor	r9d, r9d
	mov	qword [rsp+20h], 0
	mov	qword [rsp+28h], 0
	call	CreateThread
	mov	[hThread+8], rax

	mov	ecx, 2			; ハンドル数
	lea	rdx, [hThread]		; ハンドル配列
	mov	r8d, 1			; 全スレッドの終了を待つ
	mov	r9d, INFINITE
	call	WaitForMultipleObjects

	mov	rcx, [hThread]
	call	CloseHandle
	mov	rcx, [hThread+8]
	call	CloseHandle
	add	rsp, 38h

	lea	r13, [sNumI]		; π = 16×arctan(1/5) − 4×arctan(1/239)
	lea	r14, [sNum]
	call	longSub

	call	getTime
	mov	[eTime], eax

	call	ketaPrint

	mov	rdx, strEt
	call	strPrint
	mov	eax, [eTime]
	sub	eax, [sTime]
	xor	edx, edx
	mov	ecx, 1000
	div	ecx			; eax = 秒, edx = ミリ秒
	mov	[msTime], edx
	call	numPrint		; 秒を表示
	mov	rdx, strS
	call	strPrint
	mov	eax, [msTime]
	mov	rcx, 3
	call	numZPrint		; ミリ秒を3桁で表示
	mov	rdx, strMs
	call	strPrint

	xor     rcx, rcx
	call    ExitProcess

longTo:					; r12 → r13 へ複写
	cld
	mov	rcx, nKeta
	mov	rsi, r12
	mov	rdi, r13
	rep	movsq
	ret

longDiv:
	mov	rcx, nKeta
	xor	rax, rax
	mov	rbx, rax
.loop1:    
	xor	rdx, rdx
	add     [rdi + rbx * 8], rax 
	mov	rax, [rdi + rbx * 8]
	div	r8
    	mov     [rdi + rbx * 8], rax
	imul    rax, rdx, maxNum
	inc	rbx
	loop	.loop1
	ret

longAdd:				; r14 ← r14 + r13
	mov	rcx, nKeta
	mov	rsi, r13
	mov	rdi, r14
	mov	rdx, nKeta
	dec	rdx
	xor	rbx, rbx
.loop1:    
    	mov     rax, [rdi + rdx * 8]
    	add     rax, [rsi + rdx * 8]
	add	rax, rbx
	xor	rbx, rbx
    	cmp     rax, maxNum
    	jb      .label1
    	sub     rax, maxNum
	inc	rbx
.label1:
	mov	[rdi + rdx * 8], eax
	dec	rdx
	loop	.loop1
	ret

longSub:				; r14 ← r14 − r13
	mov	rcx, nKeta
	mov	rsi, r13
	mov	rdi, r14
	mov	rdx, nKeta
	dec	rdx
	xor	rbx, rbx
.loop1:    
    	mov     rax, [rdi + rdx * 8]
    	sub     rax, [rsi + rdx * 8]
	sub	rax, rbx
	xor	rbx, rbx
	or	rax,rax
    	jns     .label1
    	add     rax, maxNum
	inc	rbx
.label1:
	mov	[rdi + rdx * 8], eax
	dec	rdx
	loop	.loop1
	ret

ketaPrint:
	mov     rsi, sNum
	mov     rax, [rsi]
	call	numPrint
	mov	rdx, strPt
	call	strPrint

	mov     rcx, nKeta
	sub	rcx, 2
	mov     rdx, 1
	xor	rbx, rbx
 .loop1:   
	mov     rax, [rsi + rdx*8]
	call	num9Print
	inc     rdx
	inc	rbx
	cmp	rbx, 10
	jnz	.label1
	push	rdx
	mov	rdx, strCr
	call	strPrint
	pop	rdx
	xor	rbx, rbx
.label1:	
	loop    .loop1
	ret

initPro:
	sub     rsp, 28h
	mov     ecx, STD_OUTPUT_HANDLE
	call    GetStdHandle
	mov     [hOut], rax
	add	rsp, 28h
	ret

num9Print:
	push	rbx
	push    rcx
	push    rdx
	push    rsi
	sub     rsp, 38h
	push	rax
	lea     rdi,[strData]
	mov     rcx, strLen
	mov	al, 30h			; '0' Character
	cld
	rep     stosb
	pop	rax

	mov     rbx, 10
	xor     rcx, rcx
	lea     rdi,[strData]
	add     rdi, strLen
	dec     rdi
.label1:
	xor     rdx, rdx
	idiv    rbx 
	add     dl, 30h
	mov     [rdi], dl
	dec     rdi
	inc     rcx
	or      rax, rax
	jnz     .label1
	mov	rcx, 9
	mov     [numLen], rcx
	mov     rcx, [hOut]             ;rcx: 1st parameter
	lea     rdx, [strData]
	add     rdx, strLen
	sub     rdx, [numLen]           ;rdx: 2nd parameter
 	mov     r8, [numLen]        	;r8: 3rd parameter
	xor     r9, r9                  ;r9: 4th parameter
	mov     [rsp+ 4 * 8], r9        ;[rsp+20h] 5th parameter
	call    WriteFile
	add     rsp, 38h
	pop     rsi
	pop     rdx
	pop     rcx
	pop	rbx
	ret

numZPrint:				; rax: 数値, rcx: 表示桁数（先頭を0で埋める）
	push	rbx
	push	rcx
	push	rdx
	push	rsi
	sub	rsp, 38h
	mov	[numLen], rcx
	push	rax
	lea	rdi,[strData]
	mov	rcx, strLen
	mov	al, 30h			; '0' Character
	cld
	rep	stosb
	pop	rax

	mov	rbx, 10
	lea	rdi,[strData]
	add	rdi, strLen
	dec	rdi
.label1:
	xor	rdx, rdx
	div	rbx
	add	dl, 30h
	mov	[rdi], dl
	dec	rdi
	or	rax, rax
	jnz	.label1
	mov	rcx, [hOut]		;rcx: 1st parameter
	lea	rdx, [strData]
	add	rdx, strLen
	sub	rdx, [numLen]		;rdx: 2nd parameter
	mov	r8, [numLen]		;r8: 3rd parameter
	xor	r9, r9			;r9: 4th parameter
	mov	[rsp+ 4 * 8], r9	;[rsp+20h] 5th parameter
	call	WriteFile
	add	rsp, 38h
	pop	rsi
	pop	rdx
	pop	rcx
	pop	rbx
	ret

numPrint:
	sub     rsp, 38h                ;Home space 48
	push	rax
	lea     rdi,[strData2]
	mov     rcx, strLen2
	xor	rax, rax
	cld
	rep     stosb
	pop	rax

	mov     rbx, 10
	xor     rcx, rcx
	lea     rdi,[strData2]
	add     rdi, strLen2
	dec     rdi
.label1:
	xor     rdx, rdx
	idiv    rbx 
	add     dl, 30h
	mov     [rdi], dl
	dec     rdi
	inc     rcx
	or      rax, rax
	jnz     .label1
	mov     [numLen], rcx
	mov     rcx, [hOut]             ;rcx: 1st parameter
	lea     rdx, [strData2]
	add     rdx, strLen2
	sub     rdx, [numLen]           ;rdx: 2nd parameter
 	mov     r8, [numLen]        	;r8: 3rd parameter
	xor     r9, r9                  ;r9: 4th parameter
	mov     [rsp+ 4 * 8], r9        ;[rsp+20h] 5th parameter
	call    WriteFile
	add     rsp, 38h
	ret

strPrint:
	push    rcx
	push    rsi
	sub     rsp, 38h                ;Home space 48
	mov	rsi, rdx
	xor	rax, rax
	xor	rcx, rcx
.label2:
	cmp	byte [rsi],al
	jz	.label1
	inc	rsi
	inc	rcx
	jmp	.label2
.label1:
 	mov     r8, rcx        
	mov     rcx, [hOut]             ;rcx: 1st parameter
	xor     r9, r9                  ;r9: 4th parameter
	mov     [rsp+ 4 * 8], r9        ;[rsp+20h] 5th parameter
	call    WriteFile
	add     rsp, 38h
	pop	rsi
	pop	rcx
	ret

getTime:
	sub     rsp, 28h
	call    GetTickCount
	add	rsp, 28h
	ret

