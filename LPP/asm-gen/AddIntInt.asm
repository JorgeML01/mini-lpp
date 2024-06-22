
	push 0
	push 0
	push 0
	call inicio
	add esp, 12
	#stop

inicio:
	push ebp
	mov ebp, esp
	sub esp, 16

	; AssignStmt 
	mov eax, 65
	mov dword[ebp + 8], eax

	; AssignStmt 
	mov eax, 27
	mov dword[ebp + 12], eax

	; Suma
	mov eax, dword[ebp + 8]
	add eax, dword[ebp + 12]
	mov dword[ebp - 16], eax

	; AssignStmt 
	mov eax, dword[ebp - 16]
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
