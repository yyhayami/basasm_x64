;pi13.asm
BITS 64
DEFAULT REL

GLOBAL main

EXTERN WriteFile
EXTERN GetStdHandle
EXTERN ExitProcess

STD_OUTPUT_HANDLE equ -11
maxNum  equ  1000000000
nKeta   equ  1112
nKp	equ  7160
nKi	equ  2105

SECTION .data

strData times 20 db  0
strLen  equ $-strData
	db  13,10,0
strData2 times 20 db  0
strLen2  equ $-strData2
	db  '.', 13,10,0
crData 	db  13,10,0
crLen 	equ $-crData
	
hOut    dq  0
numLen  dq  0

sNum   	times nKeta dq  0
aNum   	times nKeta dq  0
bNum   	times nKeta dq  0

SECTION .text

calcSp:
	mov	qword [aNum], 80
	mov	r9, 1	
.loop1:
	mov	r8, 25
	mov	rdi, aNum
	call	longDiv
	call	longTo
	mov	r8, r9
	shl	r8, 1
	dec	r8
	mov	rdi, bNum
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
	ret

calcSi:
	xor	rax, rax
	mov	rcx, nKeta
	mov	rdi, aNum
	cld
	rep	stosq
	mov	qword [aNum], 956
	mov	r9, 1	
.loop1:
	mov	r8, 57121
	mov	rdi, aNum
	call	longDiv
	call	longTo
	mov	r8, r9
	shl	r8, 1
	dec	r8
	mov	rdi, bNum
	call	longDiv
	test	r9, 1
	jnz	.label1
	call	longAdd
	jmp	.label2
.label1:		
	call	longSub
.label2:
	inc	r9
	cmp	r9, nKi
	jbe	.loop1
	ret

main:
	call    initPro
	call	calcSp
	call	calcSi

	call	ketaPrint

	xor     rcx, rcx
	call    ExitProcess

longTo:
	cld
	mov	rcx, nKeta
	mov	rsi, aNum
	mov	rdi, bNum
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

longAdd:
	mov	rcx, nKeta
	mov	rsi, bNum
	mov	rdi, sNum
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

longSub:
	mov	rcx, nKeta
	mov	rsi, bNum
	mov	rdi, sNum
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
	mov     rcx, nKeta
	sub	rcx, 2
	mov     rdx, 1
	xor	rbx, rbx
 .loop1:   
	mov     rax, [rsi + rdx*8]
	call	num9Print
	inc     rdx
	loop    .loop1
	ret

initPro:
	sub     rsp, 20h
	mov     ecx, STD_OUTPUT_HANDLE
	call    GetStdHandle
	mov     [hOut], rax
	add	rsp, 20h
	ret

num9Print:
	push	rbx
	push    rcx
	push    rdx
	push    rsi
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
	inc     rcx
	or      rax, rax
	jnz     .label1
	mov	rcx, 9
	mov     [numLen], rcx
	mov     rcx, [hOut]             ;ecx: 1st parameter
	lea     rdx, [strData]
	add     rdx, strLen
	sub     rdx, [numLen]           ;rdx: 2nd parameter
 	mov     r8d, [numLen]        
	add     r8d, 2                  ;r8d: 3rd parameter
	xor     r9, r9                  ;r9: 4th parameter
	mov     [rsp+ 4 * 8], r9        ;[rsp+20h] 5th parameter
	call    WriteFile
	add     rsp, 30h
	pop     rsi
	pop     rdx
	pop     rcx
	pop	rbx
	ret

crPrint:
	push	rbx
	push    rcx
	push    rdx
	push    rsi
	sub     rsp, 30h                ;Home space 32 + params space 16
	mov     rcx, [hOut]             ;rcx: 1st parameter
	lea     rdx, [crData]		;rdx: 2nd parameter
 	mov     r8, crLen        	;r8d: 3rd parameter
	xor     r9, r9                  ;r9: 4th parameter
	mov     [rsp+ 4 * 8], r9        ;[rsp+20h] 5th parameter
	call    WriteFile
	add     rsp, 30h
	pop     rsi
	pop     rdx
	pop     rcx
	pop	rbx
	ret

numPrint:
	sub     rsp, 30h                ;Home space 32 + params space 16
	lea     rdi,[strData2]
	mov     ecx, strLen2
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
 	mov     r8d, [numLen]        
	add     r8, 3                   ;r8: 3rd parameter
	xor     r9, r9                  ;r9: 4th parameter
	mov     [rsp+ 4 * 8], r9        ;[rsp+20h] 5th parameter
	call    WriteFile
	add     rsp, 30h
	ret