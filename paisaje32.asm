.386
.model flat, stdcall
.stack 4096

; Importar funciones de kernel32.dll
include kernel32.inc
include user32.inc
includelib kernel32.lib
includelib user32.lib

ExitProcess proto :dword
WriteConsoleA proto :dword, :dword, :dword, :dword, :dword
GetStdHandle proto :dword
ReadConsoleA proto :dword, :dword, :dword, :dword, :dword

.data
    cieloMsg db "Cielo: Representado con espacios azules.", 0Ah, 0
    pastoMsg db "Pasto: Representado con espacios verdes.", 0Ah, 0
    endMsg db "Presiona cualquier tecla para salir...", 0Ah, 0
    buffer db 0                    ; Para entrada del usuario
    msgLength dd 40                ; Longitud máxima de mensajes

.code
main proc
    ; Obtener el handle de la consola estándar de salida (stdout)
    invoke GetStdHandle, -11

    ; Escribir el mensaje del cielo
    invoke WriteConsoleA, eax, offset cieloMsg, 40, 0, 0

    ; Escribir el mensaje del pasto
    invoke WriteConsoleA, eax, offset pastoMsg, 40, 0, 0

    ; Escribir el mensaje final
    invoke WriteConsoleA, eax, offset endMsg, 40, 0, 0

    ; Esperar una tecla del usuario
    invoke GetStdHandle, -10          ; Obtener el handle de la consola estándar de entrada (stdin)
    invoke ReadConsoleA, eax, offset buffer, 1, 0, 0 ; Leer una tecla

    ; Finalizar el programa
    invoke ExitProcess, 0
main endp

end main
