
	push 0
	push 0
	push 0
	call inicio
	add esp, 12
	#stop

inicio:
	push ebp
	mov ebp, esp
	sub esp, 12

	; AssignStmt 
	mov eax, 'a'
	mov dword[ebp + 8], eax
	mov eax, 1	
	mov ebx, dword[ebp + 8]	
	int 0x80	
	mov eax, 11	
	mov ebx, 10	
	int 0x80	

	; AssignStmt 
	mov eax, 10
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
