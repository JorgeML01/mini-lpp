
	push 0
	call inicio
	add esp, 4
	#stop

inicio:
	push ebp
	mov ebp, esp
	sub esp, 0

	; AssignStmt 
	mov eax, 1
	mov dword[ebp + 8], eax

	; ForStmt
for_stmt_1943901:
	mov eax, dword[ebp + 8]
	cmp eax, 100
	jg for_stmt_2943901
	mov eax, 1	
	mov ebx, dword[ebp + 8]	
	int 0x80	
	mov eax, 11	
	mov ebx, 10	
	int 0x80	

	; Incremento de la variable de control
	add dword[ebp + 8], 1
	jmp for_stmt_1943901

for_stmt_2943901:

	mov esp, ebp
	pop ebp
	ret
