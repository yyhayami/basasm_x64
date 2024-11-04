_TEXT	segment
	public asmCode5
	align 16

asmCode5 proc
	mov	rax, rcx
	mov	rcx, rdx
	xor	rdx, rdx
	idiv	rcx
	mov	[r8], rdx
	ret
asmCode5 endp
_TEXT	ends
	end