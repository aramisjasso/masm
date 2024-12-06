.model small
.stack 100h
.data
.code
inicio:
    ; Cambiar al modo texto 03h (25x80)
    mov ax, 0003h
    int 10h

    mov ax, 0B800h    ; Dirección base de la memoria de texto
    mov es, ax        ; Configuramos el segmento extra (ES)
fondo: 
    ;Cielo
    xor di, di           ; Punto inicial en la memoria de video
    mov cx, 2000         ; Doble de de los espacios a pintar
    mov ax, 0BB20h       ; Caracter ' ' (espacio) con atributo azul (1Fh)
    rep stosw            ; Repetir llenando palabras (2 bytes) en memoria

    ;Pasto
    mov di, 3520
    mov cx, 280
    mov ax, 0AA20h
    rep stosw

tecla:  
    ; Esperar una tecla para finalizar
    mov ah, 00h
    int 16h
    cmp ah, 01h
    je fin
    jmp tecla

fin: 
    ; Salir del programa
    mov ax, 4C00h
    int 21h
end inicio