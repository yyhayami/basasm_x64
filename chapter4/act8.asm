;act8.asm
BITS 64
DEFAULT REL

GLOBAL main

EXTERN WriteFile
EXTERN GetStdHandle
EXTERN ExitProcess

STD_OUTPUT_HANDLE   equ -11

SECTION .data

strData times 20 db  0
strLen  equ $-strData
	db  13,10
hOut    dq  0
num1    dq  11111
num2    dq  22222
numLen  dd  0

SECTION .text

main:
	call    initPro

	mov	rax, [num1]
	add     rax, [num2]
	call	numPrint
	xor     rcx, rcx
	call    ExitProcess

initPro:
	sub     rsp, 20h
	mov     rcx, STD_OUTPUT_HANDLE
	call    GetStdHandle
	mov     [hOut], rax
	add	rsp, 20h
	ret

numPrint:
	sub     rsp, 30h
	push	rax
    	lea     rdi,[strData]
    	mov     rcx, strLen
    	xor     rax, rax
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
   	mov     [numLen], rcx
	mov     rcx, [hOut]             ;rcx: 1st parameter
	lea     rdx, [strData]
    	add     rdx, strLen
    	sub     rdx, [numLen]           ;rdx: 2nd parameter
 	mov     r8, [numLen]        
    	add     r8, 2                   ;r8: 3rd parameter
	xor     r9, r9                  ;r9: 4th parameter
	mov     [rsp+ 4 * 8], r9        ;[rsp+20h] 5th parameter
	call    WriteFile
	add     rsp, 30h
	ret


