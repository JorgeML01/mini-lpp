
	push 0
	push 0
	call inicio
	add esp, 8
	#stop

inicio:
	push ebp
	mov ebp, esp
	sub esp, 56

	; AssignStmt 
	mov eax, 10
	mov dword[ebp + 8], eax

	; Less expr
	mov eax, dword[ebp + 8]
	cmp eax, 10
	jl less_expr_11
	mov eax, 0
	jmp less_expr_22

less_expr_11:
	mov eax, 1

less_expr_22:
	mov dword[ebp - 24], eax

	; IfStmt
	cmp dword[ebp - 24], 0
	je if_true_3
	mov eax, 1	
	mov ebx, 0	
	int 0x80	
	mov eax, 11	
	mov ebx, 10	
	int 0x80	
	jmp if_end_4

if_true_3:

	; Greater expr
	mov eax, dword[ebp + 8]
	cmp eax, 10
	jg greater_expr_15
	mov eax, 0
	jmp greater_expr_26

greater_expr_15:
	mov eax, 1

greater_expr_26:
	mov dword[ebp - 28], eax

	; IfStmt
	cmp dword[ebp - 28], 0
	je if_true_7
	mov eax, 1	
	mov ebx, 100	
	int 0x80	
	mov eax, 11	
	mov ebx, 10	
	int 0x80	
	jmp if_end_8

if_true_7:

	; Equal expr
	mov eax, dword[ebp + 8]
	cmp eax, 10
	je eq_expr_19
	mov eax, 0
	jmp eq_expr_210

eq_expr_19:
	mov eax, 1

eq_expr_210:
	mov dword[ebp - 32], eax

	; IfStmt
	cmp dword[ebp - 32], 0
	je if_true_11
	mov eax, 1	
	mov ebx, 10	
	int 0x80	
	mov eax, 11	
	mov ebx, 10	
	int 0x80	
	jmp if_end_12

if_true_11:

if_end_12:

if_end_8:

if_end_4:

	; AssignStmt 
	mov eax, 5
	mov dword[ebp + 8], eax

	; Less expr
	mov eax, dword[ebp + 8]
	cmp eax, 10
	jl less_expr_113
	mov eax, 0
	jmp less_expr_214

less_expr_113:
	mov eax, 1

less_expr_214:
	mov dword[ebp - 36], eax

	; IfStmt
	cmp dword[ebp - 36], 0
	je if_true_15
	mov esi, 0x10000000	
	lea ebx, [esi+4]	
	mov [ebx + 0], 0x274127
	mov [ebx +3], 0	
	mov eax, 4	
	lea ebx, [esi+4]	
	int 0x80	
	mov eax, 11	
	mov ebx, 10	
	int 0x80	
	jmp if_end_16

if_true_15:

	; Greater expr
	mov eax, dword[ebp + 8]
	cmp eax, 10
	jg greater_expr_117
	mov eax, 0
	jmp greater_expr_218

greater_expr_117:
	mov eax, 1

greater_expr_218:
	mov dword[ebp - 40], eax

	; IfStmt
	cmp dword[ebp - 40], 0
	je if_true_19
	mov eax, 1	
	mov ebx, 100	
	int 0x80	
	mov eax, 11	
	mov ebx, 10	
	int 0x80	
	jmp if_end_20

if_true_19:

	; Equal expr
	mov eax, dword[ebp + 8]
	cmp eax, 10
	je eq_expr_121
	mov eax, 0
	jmp eq_expr_222

eq_expr_121:
	mov eax, 1

eq_expr_222:
	mov dword[ebp - 44], eax

	; IfStmt
	cmp dword[ebp - 44], 0
	je if_true_23
	mov eax, 1	
	mov ebx, 10	
	int 0x80	
	mov eax, 11	
	mov ebx, 10	
	int 0x80	
	jmp if_end_24

if_true_23:

if_end_24:

if_end_20:

if_end_16:

	; AssignStmt 
	mov eax, 73
	mov dword[ebp + 8], eax

	; Less expr
	mov eax, dword[ebp + 8]
	cmp eax, 10
	jl less_expr_125
	mov eax, 0
	jmp less_expr_226

less_expr_125:
	mov eax, 1

less_expr_226:
	mov dword[ebp - 48], eax

	; IfStmt
	cmp dword[ebp - 48], 0
	je if_true_27
	mov eax, 1	
	mov ebx, 0	
	int 0x80	
	mov eax, 11	
	mov ebx, 10	
	int 0x80	
	jmp if_end_28

if_true_27:

	; Greater expr
	mov eax, dword[ebp + 8]
	cmp eax, 10
	jg greater_expr_129
	mov eax, 0
	jmp greater_expr_230

greater_expr_129:
	mov eax, 1

greater_expr_230:
	mov dword[ebp - 52], eax

	; IfStmt
	cmp dword[ebp - 52], 0
	je if_true_31
	mov eax, 1	
	mov ebx, 100	
	int 0x80	
	mov eax, 11	
	mov ebx, 10	
	int 0x80	
	jmp if_end_32

if_true_31:

	; Equal expr
	mov eax, dword[ebp + 8]
	cmp eax, 10
	je eq_expr_133
	mov eax, 0
	jmp eq_expr_234

eq_expr_133:
	mov eax, 1

eq_expr_234:
	mov dword[ebp - 56], eax

	; IfStmt
	cmp dword[ebp - 56], 0
	je if_true_35
	mov eax, 1	
	mov ebx, 10	
	int 0x80	
	mov eax, 11	
	mov ebx, 10	
	int 0x80	
	jmp if_end_36

if_true_35:

if_end_36:

if_end_32:

if_end_28:

	mov esp, ebp
	pop ebp
	ret
