
	push 0
	push 0
	call inicio
	add esp, 8
	#stop

inicio:
	push ebp
	mov ebp, esp
	sub esp, 20

	; AssignStmt 
	mov eax, 567
	mov dword[ebp + 8], eax

	; AssignStmt 
	mov eax, 765
	mov dword[ebp + 12], eax

	; AssignStmt 
	mov eax, 374
	mov dword[ebp + 8], eax

	; AssignStmt 
	mov eax, 473
	mov dword[ebp + 12], eax

	mov esp, ebp
	pop ebp
	ret
