.model small
.stack 100h

.data
    ;mensaje db "Presiona cualquier tecla para finalizar...", "$"

.code
    start:
    ; Cambiar al modo texto 03h (25x80)
          mov ax, 0003h
          int 10h

    ; Dibujar un punto rojo en el centro (ASCII 219)
          mov ax, 0B800h    ; Dirección base de la memoria de texto
          mov es, ax        ; Configuramos el segmento extra (ES)

    ;mov bx, 80           ; Calcula el desplazamiento
    ;mov cx, 12
    ;mul cx           ; Multiplica bx por 12
    ;add bx, 40           ; bx = bx + 40 (columna 40)
    ;shl bx, 1            ; bx = bx * 2 (cada celda ocupa 2 bytes)
    ;mov al, 219          ; Caracter ASCII del bloque sólido
    ;mov ah, 4            ; Atributo: Color rojo sobre fondo negro
    ;mov es:[bx], ax   ; Escribe en memoria usando ES

    ; Posición del carácter
    ;mov bx, 80      ; Fila 1 (multiplica por 80 columnas)
    ;mov cx, 5       ; Columna 6
    ;mul cx          ; Calcula desplazamiento: fila*columna
    ;shl bx, 1       ; Cada celda ocupa 2 bytes

    ; Carácter y color
    ;mov al, 'A'     ; Carácter ASCII
    ;mov ah, 0Eh     ; Atributo: amarillo sobre negro
    ;mov es:[bx], ax ; Escribe en memoria
    mov ah, 02h       ; Función para mover el cursor
    mov bh, 0         ; Página de video
    mov dh, 5         ; Fila (posición Y)
    mov dl, 10        ; Columna (posición X)
    int 10h           ; Llamada a BIOS para posicionar el cursor

    mov ah, 09h       ; Función para escribir carácter con atributo
    mov al, 'A'       ; Carácter a imprimir
    mov bl, 1Fh       ; Atributo de color (fondo negro, texto blanco brillante)
    mov cx, 10        ; Cantidad de veces que se imprime
    int 10h           ; Llamada a BIOS para imprimir



    ; Mostrar el mensaje
    ;lea dx, mensaje
    ;mov ah, 09h          ; Función DOS para imprimir cadenas
    ;int 21h

    ; Esperar una tecla para finalizar
          mov ah, 00h
          int 16h

    ; Salir del programa
          mov ax, 4C00h
          int 21h
end start
