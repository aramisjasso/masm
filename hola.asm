.386
.model flat, stdcall
.stack 4096

; Importar funciones de kernel32.dll
includelib kernel32.lib
ExitProcess proto :dword
WriteConsoleA proto :dword, :dword, :dword, :dword, :dword
GetStdHandle proto :dword
ReadConsoleA proto :dword, :dword, :dword, :dword, :dword

.data
    helloMsg db "Hello, World!", 0Ah, 0
    msgLength dd 14               ; Longitud del mensaje (incluye el 0Ah y el terminador)
    input db 0                    ; Buffer para almacenar la tecla leída

.code
main proc
    ; Obtener el handle de la consola estándar de salida (stdout)
    invoke GetStdHandle, -11

    ; Escribir el mensaje en la consola
    invoke WriteConsoleA, eax, offset helloMsg, msgLength, 0, 0

    ; Esperar una tecla
    invoke GetStdHandle, -10          ; Obtener el handle de la consola estándar de entrada (stdin)
    invoke ReadConsoleA, eax, offset input, 1, 0, 0 ; Leer una tecla (1 carácter)

    ; Finalizar el programa
    invoke ExitProcess, 0
main endp

end main
