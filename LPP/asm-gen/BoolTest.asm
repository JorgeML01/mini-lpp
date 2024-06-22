
	push 0
	call inicio
	add esp, 4
	#stop

inicio:
	push ebp
	mov ebp, esp
	sub esp, 12

	; AssignStmt 
	mov eax, 1
	mov dword[ebp + 8], eax
	mov eax, 1	
	mov ebx, dword[ebp + 8]	
	int 0x80	
	mov eax, 11	
	mov ebx, 10	
	int 0x80	

	; AssignStmt 
	mov eax, 0
	mov dword[ebp + 8], eax
	mov eax, 1	
	mov ebx, dword[ebp + 8]	
	int 0x80	
	mov eax, 11	
	mov ebx, 10	
	int 0x80	

	mov esp, ebp
	pop ebp
	ret
