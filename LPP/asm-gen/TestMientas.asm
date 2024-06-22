
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

; WhileStmt
while_stmt_1943301:

	; LessOrEqual expr
	mov eax, dword[ebp + 8]
	cmp eax, 100
	jle less_eq_expr_1943301
	mov eax, 0
	jmp less_eq_expr_2943301

less_eq_expr_1943301:
	mov eax, 1

less_eq_expr_2943301:
	mov dword[ebp - 8], eax
	cmp dword[ebp - 8], 0
	je while_stmt_2943301
	mov eax, 1	
	mov ebx, dword[ebp + 8]	
	int 0x80	
	mov eax, 11	
	mov ebx, 10	
	int 0x80	

	; Suma
	mov eax, dword[ebp + 8]
	add eax, 1
	mov dword[ebp - 16], eax

	; AssignStmt 
	mov eax, dword[ebp - 16]
	mov dword[ebp + 8], eax
	jmp while_stmt_1943301

	while_stmt_2943301:

	mov esp, ebp
	pop ebp
	ret
