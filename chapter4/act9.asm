;act9.asm
BITS 64
DEFAULT REL

%use altreg 

GLOBAL main

EXTERN WriteFile
EXTERN GetStdHandle
EXTERN ExitProcess

STD_OUTPUT_HANDLE equ -11

SECTION .data

strData times 20 db  '0'
strLen  equ $-strData
	db  13,10
hOut    dq  0
num1    dq  2
        dq  400000001
num2    dq  3
        dq  600000002
num3    dq  0
        dq  0
numLen  dq  0

maxNum  equ 1000000000
nKe 	equ 9

SECTION .text

main:
    	call    initPro
	mov	r0, [num1+8]
    	add     r0, [num2+8]
    	mov     [num3+8], r0
    	cmp     r0, maxNum
    	jb     .label2
    	inc     qword [num3]
    	sub     qword [num3+8], maxNum
.label2:
	mov	r0, [num1]
    	add     r0, [num2]
    	add     [num3], r0
    	mov     r0, [num3]
	call	numPrint
    	mov     r0, [num3+8]
	call	numkPrint
    	xor     r1, r1
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

