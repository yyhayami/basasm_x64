;act10.asm
BITS 64
DEFAULT REL

GLOBAL main

EXTERN WriteFile
EXTERN GetStdHandle
EXTERN ExitProcess

STD_OUTPUT_HANDLE equ -11

SECTION .data

strData times 20 db  0
strLen  equ $-strData
	db	13,10,0
hOut    dq  0
num1    dq  4
        dq  400000002
num2    dq  2
        dq  600000001
num3    dq  0
        dq  0

numLen  dq  0

maxNum  equ 1000000000
nKe 	equ 9

SECTION .text

main:
    	call    initPro

	mov	rax, [num1+8]
    	sub     rax, [num2+8]
    	jae     .label2
    	add     rax, maxNum
    	dec     qword [num1]
.label2:
    	mov     [num3+8], rax
	mov	rax, [num1]
    	sub     rax, [num2]
    	add     [num3], eax

    	mov     rax, [num3]
	call	numPrint

    	mov     rax, [num3+8]
	call	numkPrint

    	xor     rcx, rcx
	call    ExitProcess

initPro:
	sub     rsp, 20h
	mov     rcx, STD_OUTPUT_HANDLE
	call    GetStdHandle
    	mov     [hOut], rax
	add	rsp, 20h
    	ret

numkPrint:
	sub     rsp, 30h
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
	or      rax, rax
	jnz     .label1
	mov	rcx, nKe
	mov     [numLen], rcx
	mov     rcx, [hOut]             ;rcx: 1st parameter
	lea     rdx, [strData]
	add     rdx, strLen
	sub     rdx, [numLen]           ;rdx: 2nd parameter
 	mov     r8, [numLen]
    	add     r8, 2       		;r8: 3rd parameter            
	xor     r9, r9                  ;r9: 4th parameter
	mov     [rsp+ 4 * 8], r9        ;[rsp+20h] 5th parameter
	call    WriteFile
	add     rsp, 30h
	ret

numPrint:
	sub     rsp, 30h
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
    	mov     [numLen], rcx
	mov     rcx, [hOut]             ;rcx: 1st parameter
	lea     rdx, [strData]
    	add     rdx, strLen
    	sub     rdx, [numLen]          	;rdx: 2nd parameter
 	mov     r8, [numLen]        	;r8: 3rd parameter
	xor     r9, r9                  ;r9: 4th parameter
	mov     [rsp+ 4 * 8], r9        ;[rsp+20h] 5th parameter
	call    WriteFile
	add     rsp, 30h
	ret