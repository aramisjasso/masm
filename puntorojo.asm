.386
.model flat, stdcall
.stack 4096

include kernel32.inc
includelib kernel32.lib

ExitProcess proto :dword
WriteConsoleOutput proto :dword, :dword, :dword, :dword, :dword
GetStdHandle proto :dword
ReadConsoleInput proto :dword, :dword, :dword, :dword

CHAR_INFO struct
    Char db 1
    Attributes db 1
CHAR_INFO ends

COORD struct
    X dw ?
    Y dw ?
COORD ends

SMALL_RECT struct
    Left dw ?
    Top dw ?
    Right dw ?
    Bottom dw ?
SMALL_RECT ends

INPUT_RECORD struct
    EventType dw ?
    EventUnion db 16 dup(?)
INPUT_RECORD ends

.data
INVALID_HANDLE_VALUE equ -1
centerChar CHAR_INFO <'O', 4>        ; Carácter 'O' con texto rojo
bufferSize COORD <1, 1>             ; Dimensiones del búfer (1x1)
bufferCoord COORD <0, 0>            ; Coordenada de inicio del búfer
region SMALL_RECT <0, 0, 0, 0>   ; Escribir en la esquina superior izquierda
inputRecord INPUT_RECORD <>         ; Para manejar la entrada
eventsRead dd 0                     ; Número de eventos leídos
    debugMessage1 db "Paso 1: Obtenido handle de consola de salida", 0
    debugMessage2 db "Paso 2: Caracter escrito en consola", 0
    debugMessage3 db "Paso 3: Esperando entrada del usuario", 0
    debugError db "Error: No se pudo obtener handle", 0
    eventsReadMessage db "Eventos leídos: ", 0
    newline db 13, 10, 0

.code
main proc
    ; Obtener el handle de la consola de salida
    invoke GetStdHandle, -11
    cmp eax, INVALID_HANDLE_VALUE
    je handle_error
    mov ebx, eax

    ; Mensaje de depuración
    invoke WriteConsoleA, ebx, offset debugMessage1, sizeof debugMessage1 - 1, 0, 0

    ; Escribir el carácter 'O' en el centro de la consola
    invoke WriteConsoleOutput, ebx, offset centerChar, offset bufferSize, offset bufferCoord, offset region

    ; Mensaje de depuración
    invoke WriteConsoleA, ebx, offset debugMessage2, sizeof debugMessage2 - 1, 0, 0

    ; Esperar entrada del usuario
    invoke GetStdHandle, -10         ; Obtener handle de entrada
    mov ebx, eax

    ; Mensaje de depuración
    invoke WriteConsoleA, ebx, offset debugMessage3, sizeof debugMessage3 - 1, 0, 0

wait_input:
    invoke ReadConsoleInput, ebx, offset inputRecord, 1, offset eventsRead

    ; Mostrar eventos leídos
    invoke WriteConsoleA, ebx, offset eventsReadMessage, sizeof eventsReadMessage - 1, 0, 0
    invoke WriteConsoleA, ebx, offset newline, sizeof newline - 1, 0, 0

    cmp eventsRead, 0                ; Verificar si se leyó algo
    je wait_input                    ; Esperar hasta que haya entrada

    ; Salir del programa
    invoke ExitProcess, 0

handle_error:
    ; Mostrar mensaje de error
    invoke WriteConsoleA, ebx, offset debugError, sizeof debugError - 1, 0, 0
    invoke ExitProcess, 1
main endp


end main
