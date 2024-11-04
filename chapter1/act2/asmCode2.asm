_TEXT	segment
	public asmCode2
	align 16

asmCode2 proc
	add	qword ptr [rcx], rdx
	ret
asmCode2 endp
_TEXT	ends
	end
