GetStdHandle	proto :QWORD
WriteConsoleA	proto :PTR, :PTR, :QWORD, :PTR, :QWORD
ExitProcess	proto :QWORD

.DATA
	output	db "Hello Axol2D", 13, 10, 0
	outlen	equ $ - output

.CODE
main proc
	sub rsp, 28h                     ; Reservamos espacio para alineación de pila a 16 bytes

	; Obtener el manejador de salida estándar
	mov rcx, -11                      ; STD_OUTPUT_HANDLE en RCX (0xFFFFFFF5)
	call GetStdHandle                 ; GetStdHandle(STD_OUTPUT_HANDLE)
	
	; Preparar parámetros para WriteConsoleA
	mov qword ptr [rsp + 20h], 0      ; lpReserved (null pointer), en la pila
	mov r9, 0                         ; lpNumberOfCharsWritten (null pointer), en R9
	mov r8, outlen                    ; nNumberOfCharsToWrite, en R8
	mov rdx, OFFSET output            ; lpBuffer, en RDX
	mov rcx, rax                      ; hConsoleOutput, en RCX (resultado de GetStdHandle)
	call WriteConsoleA                ; Llamamos a WriteConsoleA

	; Finalizamos el programa
	;xor rcx, rcx                      ; Exit code = 0, en RCX
	mov ax,0
	call ExitProcess                  ; Llamamos a ExitProcess

	add rsp, 28h                      ; Restauramos el stack pointer
main endp
END
