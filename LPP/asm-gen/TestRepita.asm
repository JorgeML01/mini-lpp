
	push 0
	call inicio
	add esp, 4
	#stop

inicio:
	push ebp
	mov ebp, esp
	sub esp, 16

	; AssignStmt 
	mov eax, 1
	mov dword[ebp + 8], eax

; RepitaStmt
repita_stmt_11:
	mov eax, 1	
	mov ebx, dword[ebp + 8]	
	int 0x80	
	mov eax, 11	
	mov ebx, 10	
	int 0x80	

	; Suma
	mov eax, dword[ebp + 8]
	add eax, 1
	mov dword[ebp - 12], eax

	; AssignStmt 
	mov eax, dword[ebp - 12]
	mov dword[ebp + 8], eax

	; Greater expr
	mov eax, dword[ebp + 8]
	cmp eax, 100
	jg greater_expr_13
	mov eax, 0
	jmp greater_expr_24

greater_expr_13:
	mov eax, 1

greater_expr_24:
	mov dword[ebp - 16], eax
	cmp dword[ebp - 16], 1
	je repita_stmt_22
	jmp repita_stmt_11

	repita_stmt_22:

	mov esp, ebp
	pop ebp
	ret
