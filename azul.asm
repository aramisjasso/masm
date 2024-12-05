.386
.model flat, stdcall
.stack 4096

include kernel32.inc
includelib kernel32.lib

ExitProcess proto :dword
WriteConsoleOutput proto :dword, :dword, :dword, :dword, :dword
GetStdHandle proto :dword
ReadConsoleInput proto :dword, :dword, :dword, :dword
WriteConsoleA proto :dword, :dword, :dword, :dword, :dword

CHAR_INFO struct
    Char db 1                   ; Carácter (un byte para ASCII)
    Attributes db 1             ; Atributos (color del texto y fondo)
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
    EventUnion db 16 dup(?)      ; Espacio para eventos
INPUT_RECORD ends

.data
    INVALID_HANDLE_VALUE equ -1            ; Definición explícita
    screenBuffer CHAR_INFO 2000 dup(<' ', 0>) ; Búfer para 80x25 caracteres
    bufferSize COORD <80, 25>                ; Tamaño del búfer
    bufferCoord COORD <0, 0>                 ; Coordenadas del inicio del búfer
    region SMALL_RECT <0, 0, 79, 24>         ; Región de la pantalla a modificar

    inputRecord INPUT_RECORD <>              ; Almacena eventos de entrada
    eventsRead dd 0                          ; Almacena el número de eventos leídos

    errorMessage db "Error: Invalid handle. Press any key to exit.", 0
    messageLength dd 43                      ; Longitud del mensaje

.code
main proc
    ; Obtener el handle de la consola de salida
    invoke GetStdHandle, -11
    mov ebx, eax                             ; Guardar el handle

    ; Verificar si el handle es válido
    cmp ebx, INVALID_HANDLE_VALUE
    je handle_error                          ; Mostrar mensaje y salir

    ; Llenar el búfer con el carácter 'A' y fondo azul
    mov ecx, 2000                            ; Total de celdas (80 x 25)
    mov esi, offset screenBuffer
fill_buffer:
    mov byte ptr [esi], 'A'                  ; Carácter 'A'
    mov byte ptr [esi+1], 1Fh                ; Texto blanco sobre fondo azul
    add esi, 2                               ; Avanzar al siguiente CHAR_INFO
    loop fill_buffer

    ; Escribir el búfer en la consola
    invoke WriteConsoleOutput, ebx, offset screenBuffer, offset bufferSize, offset bufferCoord, offset region

    ; Esperar un evento de entrada
    invoke GetStdHandle, -10                 ; Obtener el handle de entrada (stdin)
    mov ebx, eax                             ; Guardar el handle de entrada

wait_input:
    invoke ReadConsoleInput, ebx, offset inputRecord, 1, offset eventsRead
    cmp eventsRead, 0                        ; Verificar si se leyó algo
    je wait_input                            ; Esperar hasta que haya entrada

exit_program:
    ; Salir del programa
    invoke ExitProcess, 0

handle_error:
    ; Obtener handle de salida estándar para escribir mensaje
    invoke GetStdHandle, -11
    mov ebx, eax
    invoke WriteConsoleA, ebx, offset errorMessage, messageLength, 0, 0

    ; Esperar una tecla para salir
    invoke GetStdHandle, -10
    mov ebx, eax
    invoke ReadConsoleInput, ebx, offset inputRecord, 1, offset eventsRead

    ; Salir
    invoke ExitProcess, 1
main endp

end main
