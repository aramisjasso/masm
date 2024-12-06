.386
.model flat, stdcall
.stack 4096

include kernel32.inc
includelib kernel32.lib

ExitProcess proto :dword
SetConsoleCursorPosition proto :dword, :dword
SetConsoleTextAttribute proto :dword, :dword
WriteConsole proto :dword, :dword, :dword, :dword, :dword
ReadConsole proto :dword, :dword, :dword, :dword, :dword
GetStdHandle proto :dword

COORD struct
    X dw ?
    Y dw ?
COORD ends

.data
INVALID_HANDLE_VALUE equ -1
charText db "A", 0                ; Carácter a imprimir
textLength dd 1                  ; Longitud del texto
cursorPos COORD <10, 10>           ; Posición del cursor (5,5)
stdoutHandle dd ?                ; Handle de la consola
stdinHandle dd ?                 ; Handle de entrada estándar
inputBuffer db 16 dup(?)         ; Búfer para la entrada del usuario
bytesRead dd 0                   ; Bytes leídos

.code
main proc
    ; Obtener el handle de la consola de salida
    invoke GetStdHandle, -11
    cmp eax, INVALID_HANDLE_VALUE
    je exit_error                 ; Salir si falla
    mov stdoutHandle, eax         ; Guardar el handle

    ; Establecer la posición del cursor en (5,5)
    invoke SetConsoleCursorPosition, stdoutHandle, offset cursorPos

    ; Cambiar el color del texto (07h = blanco sobre fondo negro)
    invoke SetConsoleTextAttribute, stdoutHandle, 1Fh

    ; Escribir el carácter 'A' en la posición especificada
    invoke WriteConsole, stdoutHandle, offset charText, textLength, 0, 0

    ; Obtener el handle de entrada estándar (stdin)
    invoke GetStdHandle, -10
    mov stdinHandle, eax

    ; Pausar esperando la entrada del usuario
    invoke ReadConsole, stdinHandle, offset inputBuffer, sizeof inputBuffer, offset bytesRead, 0

    ; Salir del programa
    invoke ExitProcess, 0

exit_error:
    invoke ExitProcess, 1
main endp

end main
