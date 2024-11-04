;act7.asm
BITS 64
DEFAULT REL

GLOBAL main

STD_OUTPUT_HANDLE equ -11

extern GetStdHandle
extern WriteFile
extern ExitProcess

section .data
strData		db 'Hello world!', 0Dh, 0Ah
strLen		equ $-strData

section .bss
hOut		resq	1
Written        	resq	1

section .text

main:
	sub   rsp, 32
	mov   rcx, STD_OUTPUT_HANDLE
	call  GetStdHandle
	mov   [hOut], rax
	add   rsp, 32

 	sub   rsp, 32 + 8 + 8
 	mov   rcx, [hOut]			; 1st parameter
	lea   rdx, [strData]                    ; 2nd parameter
	mov   R8, strLen                	; 3rd parameter
	lea   R9, [Written] 	                ; 4th parameter
	mov   qword [rsp + 4 * 8], 0            ; 5th parameter
	call  WriteFile
	add   rsp, 48

	xor   rcx, rcx
	call  ExitProcess

