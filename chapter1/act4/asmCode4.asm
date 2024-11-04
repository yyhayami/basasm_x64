_TEXT	segment
	public asmCode4
	align 16

asmCode4 proc
	imul	rcx,rdx
	mov	rax,rcx
	ret
asmCode4 endp
_TEXT	ends
	end