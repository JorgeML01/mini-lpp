
	push 0
	push 0
	push 0
	push 0
	push 0
	push 0
	push 0
	push 0
	push 0
	call inicio
	add esp, 36
	#stop

inicio:
	push ebp
	mov ebp, esp
	sub esp, 4

	; AssignStmt 
	mov eax, 3
	mov dword[ebp + 32], eax
	mov esi, 0x10000000	
	lea ebx, [esi+4]	
	mov [ebx + 0], 0x616c6f48
	mov [ebx + 4], 0x6e754d20
	mov [ebx + 8], 0x6f64
	mov [ebx +10], 0	
	mov eax, 4	
	lea ebx, [esi+4]	
	int 0x80	
	mov eax, 11	
	mov ebx, 10	
	int 0x80	

	mov esp, ebp
	pop ebp
	ret
