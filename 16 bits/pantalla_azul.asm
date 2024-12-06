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

    ; Llenar la pantalla con color azul
    xor di, di           ; Empezamos desde el inicio de la memoria de video
    mov cx, 20         ; 25 filas * 80 columnas * 2 bytes por celda
    mov ax, 0BB20h        ; Caracter ' ' (espacio) con atributo azul (1Fh)
rep stosw                ; Repetir llenando palabras (2 bytes) en memoria

    ; Esperar una tecla para finalizar
    mov ah, 00h
    int 16h

    ; Salir del programa
    mov ax, 4C00h
    int 21h
end start
