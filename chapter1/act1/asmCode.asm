_TEXT	segment
	public asmCode
	align 16

asmCode	proc
	mov dword ptr [rcx], edx
	ret
asmCode	endp
_TEXT	ends
	end
