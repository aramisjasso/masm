.model small
.stack 100h

.data
;mensaje db "Presiona cualquier tecla para finalizar...", "$"

.code
start:
    ; Cambiar al modo texto 03h (25x80)
    mov ax, 0003h
    int 10h


; Dirección base de la memoria de video
mov ax, 0B800h
mov es, ax

; Configurar atributos
mov al, '#'       ; Carácter ASCII
mov ah, 3Fh       ; Color: texto cian sobre fondo gris oscuro

; Dibujar rectángulo (5 filas, 10 columnas)
mov si, 0         ; Inicio en la esquina superior izquierda
mov di, 80        ; Avanzar por filas (80 columnas por fila)
mov cx, 5         ; Altura (5 filas)
RectLoop:
    push cx       ; Guarda el contador de filas
    mov cx, 10    ; Número de columnas
ColLoop:
    mov es:[si], ax ; Escribe carácter y color
    add si, 2     ; Avanzar a la siguiente celda
    loop ColLoop
    add si, di    ; Avanzar a la siguiente fila
    sub si, 20    ; Ajusta por columnas dibujadas
    pop cx        ; Restaura contador de filas
    loop RectLoop

    mov ah, 00h
    int 16h

    ; Salir del programa
    mov ax, 4C00h
    int 21h 
end start