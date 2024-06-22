
	push 0
	push 0
	push 0
	push 0
	call inicio
	add esp, 16
	#stop

inicio:
	push ebp
	mov ebp, esp
	sub esp, 32

	; AssignStmt 
	mov eax, 65
	mov dword[ebp + 20], eax

	; AssignStmt 
	mov eax, 11
	mov dword[ebp + 8], eax

	; AssignStmt 
	mov eax, 3
	mov dword[ebp + 12], eax

	; Módulo usando restas
	mov eax, dword[ebp + 8]
	mov dword[ebp - 24], eax
	mov ebx, dword[ebp + 12]
	cmp ebx, 0
	je end_mod2
loop_mod1:
	mov eax, dword[ebp - 24]
	cmp eax, ebx
	jl end_mod2
	sub eax, ebx
	mov dword[ebp - 24], eax
	jmp loop_mod1
end_mod2:
	mov eax, dword[ebp - 24]
	mov dword[ebp - 32], eax
	mov dword[ebp - 20], eax

	; AssignStmt 
	mov eax, dword[ebp - 20]
	mov dword[ebp + 16], eax
	mov eax, 1	
	mov ebx, dword[ebp + 16]
	int 0x80	
	mov eax, 11	
	mov ebx, 10	
	int 0x80	

	mov esp, ebp
	pop ebp
	ret
