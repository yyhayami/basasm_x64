;longdiv.asm
BITS 64
DEFAULT REL

GLOBAL main

EXTERN WriteFile
EXTERN GetStdHandle
EXTERN ExitProcess

STD_OUTPUT_HANDLE equ  -11
maxNum  equ  100000
nKe	equ  5
nKeta   equ  4

SECTION .data

strData times 20 db  '0'
strLen  equ $-strData
	db  13,10,0
hOut    dq  0
numLen  dq  0

num1    dq  5,12,4,50
num2    dq  5

SECTION .text

main:
	call    initPro
	call	longDiv
	call	ketaPrint

	xor     rcx, rcx
	call    ExitProcess

longDiv:
	mov	rcx, nKeta
	mov	rdi, num1
	mov	r8, [num2]
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

ketaPrint:
	mov     rsi, num1
	mov     rax, [rsi]
	call	numPrint
	mov     rcx, nKeta
	dec	rcx
	mov	rdx, 1
 .loop1:   
	mov     rax, [rsi + rdx*8]
	push    rcx
	push    rdx
	push    rsi
	call	numkPrint
	pop     rsi
	pop     rdx
	pop     rcx
	inc     rdx
	loop    .loop1
	ret

initPro:
	sub     rsp, 20h
	mov     rcx, STD_OUTPUT_HANDLE
	call    GetStdHandle
	mov     [hOut], rax
	add	rsp, 20h
	ret

numkPrint:
	sub     rsp, 30h
	push	rax
	lea     rdi,[strData]
	mov     ecx, strLen
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
 	mov     r8, [numLen]
    	add     r8, 2       		;r8: 3rd parameter            
	xor     r9, r9                  ;r9: 4th parameter
	mov     [rsp+ 4 * 8], r9        ;[rsp+20h] 5th parameter
	call    WriteFile
	add     rsp, 30h
	ret

