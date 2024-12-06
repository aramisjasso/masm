.386
.model flat, stdcall
.stack 4096

include kernel32.inc
includelib kernel32.lib

; Constantes
STD_OUTPUT_HANDLE equ -11
INVALID_HANDLE_VALUE equ -1

; Estructuras
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

CONSOLE_SCREEN_BUFFER_INFO struct
    dwSize COORD <>
    dwCursorPosition COORD <>
    wAttributes dw ?
    srWindow SMALL_RECT <>
    dwMaximumWindowSize COORD <>
CONSOLE_SCREEN_BUFFER_INFO ends

; Datos
.data
stdoutHandle dd ?                          ; Handle de salida estándar
bufferInfo CONSOLE_SCREEN_BUFFER_INFO <>   ; Estructura de información del búfer
textWidth db "Screen Width: ", 0
textHeight db "Screen Height: ", 0
newLine db 13, 10, 0                       ; Salto de línea
outputBuffer db 16 dup(0)                  ; Buffer para números (máximo 16 dígitos)

stdinHandle dd ?                
inputBuffer db 16 dup(?)         
bytesRead dd 0                  
charsWritten dd ?    

; Código
.code
main proc
    ; Obtener el handle de la consola estándar
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    cmp eax, INVALID_HANDLE_VALUE
    je exit_error                          ; Salir si falla
    mov stdoutHandle, eax

    ; Obtener información del búfer de pantalla
    invoke GetConsoleScreenBufferInfo, stdoutHandle, offset bufferInfo
    cmp eax, 0
    je exit_error                          ; Salir si falla

    ; Imprimir ancho
    invoke WriteConsoleA, stdoutHandle, offset textWidth, sizeof textWidth - 1, 0, 0
    movzx eax, bufferInfo.dwSize.X         ; Obtener ancho
    call PrintNumber                       ; Llamar a la rutina de impresión
    invoke WriteConsoleA, stdoutHandle, offset newLine, sizeof newLine - 1, 0, 0

    ; Imprimir alto
    invoke WriteConsoleA, stdoutHandle, offset textHeight, sizeof textHeight - 1, 0, 0
    movzx eax, bufferInfo.dwSize.Y         ; Obtener alto
    call PrintNumber                       ; Llamar a la rutina de impresión
    invoke WriteConsoleA, stdoutHandle, offset newLine, sizeof newLine - 1, 0, 0

    invoke GetStdHandle, -10
    mov stdinHandle, eax

    invoke ReadConsole, stdinHandle, offset inputBuffer, sizeof inputBuffer, offset bytesRead, 0


    ; Salir con éxito
    invoke ExitProcess, 0

exit_error:
    invoke ExitProcess, 1

; Rutina para imprimir un número en la consola
PrintNumber proc
    push eax                               ; Guardar el número original
    lea esi, outputBuffer + 15             ; Apuntar al final del buffer
    mov byte ptr [esi], 0                  ; Null terminator

    ; Convertir el número a ASCII
    mov ecx, 10                            ; Base 10
itoa_loop:
    xor edx, edx
    div ecx                                ; EAX = EAX / 10, EDX = residuo
    add dl, '0'                            ; Convertir a carácter
    dec esi
    mov [esi], dl
    test eax, eax                          ; ¿EAX == 0?
    jnz itoa_loop

    ; Imprimir el número convertido
    push 0                        ; Último parámetro lpNumberOfBytesWritten
    push 0                        ; lpReserved
    mov eax, esi
    lea ecx, outputBuffer       ; Cargar la dirección base de outputBuffer
    add ecx, 15                 ; Desplazarse 15 posiciones hacia adelante
    sub ecx, eax                  ; Longitud calculada
    push ecx                      ; Número de caracteres a escribir
    push esi                      ; Dirección del buffer
    push stdoutHandle             ; Handle de consola
    call WriteConsoleA            ; Llamada directa
    pop eax                                ; Restaurar EAX
    ret
PrintNumber endp

main endp
end main
