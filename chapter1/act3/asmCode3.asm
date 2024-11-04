_TEXT	segment
	public asmCode3
	align 16

asmCode3 proc
	sub	rcx,rdx
	mov	rax,rcx
	ret
asmCode3 endp
_TEXT	ends
	end