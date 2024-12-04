.model small
.stack 100h

.code
start:
    ; Cambiar al modo texto 03h (25x80)
    mov ax, 0003h
    int 10h

    ; Configurar segmento de memoria de video
    mov ax, 0B800h       ; Dirección base de la memoria de texto
    mov es, ax           ; Configuramos el segmento extra (ES)

    ; Dibujar ladrillos alternados
    xor di, di           ; Empezamos desde el inicio de la memoria de video

    mov cx, 25           ; 25 filas
row_loop:
    push cx              ; Guardar contador de filas
    mov cx, 40           ; 80 columnas / 2 (cada celda son 2 bytes)

    xor bx, bx           ; Alternar entre negro y gris (usando BX como marcador)
brick_loop:
    mov al, ' '          ; Caracter espacio como ladrillo
    test bx, 1           ; Revisar bit 0 de BX para alternar color
    jz black_brick
    mov ah, 07h          ; Gris claro sobre fondo negro
    jmp draw_brick
black_brick:
    mov ah, 00h          ; Negro sobre fondo negro
draw_brick:
    mov es:[di], ax      ; Escribir el ladrillo en pantalla
    add di, 2            ; Avanzar al siguiente carácter (2 bytes por celda)
    inc bx               ; Alternar para el siguiente ladrillo
    loop brick_loop      ; Repetir para toda la fila

    pop cx               ; Recuperar contador de filas
    add di, 80           ; Saltar al inicio de la siguiente fila
    loop row_loop        ; Repetir para todas las filas

    ; Esperar una tecla para finalizar
    mov ah, 00h
    int 16h

    ; Salir del programa
    mov ax, 4C00h
    int 21h
end start
