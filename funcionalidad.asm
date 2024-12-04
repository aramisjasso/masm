.model small
.stack 100h
.data
    ren DB 19
    col DB 2
.code
inicio:
    mov ax, 03h        ; Cambiar al modo texto 03h
    int 10h

    mov ax, 0B800h     ; Dirección base de la memoria de texto
    mov es, ax         ; Configuramos el segmento extra (ES)

    ; Llenar el cielo
    xor di, di
    mov cx, 2000
    mov ax, 0BB20h
    rep stosw

    ; Llenar el pasto
    mov di, 3520
    mov cx, 280
    mov ax, 0AA20h
    rep stosw

    ; Dibujar personaje inicial
    mov ren, 19
    mov col, 2
    call redibujar

tecla:
    ; Leer tecla
    mov ah, 00h
    int 16h

    ; Manejar flechas
    cmp ah, 48h
    je arriba
    cmp ah, 50h
    je abajo
    cmp ah, 4Bh
    je izquierda
    cmp ah, 4Dh
    je derecha

    ; Si no es flecha, salir
    cmp ah, 01h
    je fin
    jmp tecla

fin:
    mov ax, 4C00h
    int 21h

arriba:
    call borrar
    cmp ren, 0
    je tecla
    dec ren
    call redibujar
    jmp tecla

abajo:
    call borrar
    cmp ren, 24
    je tecla
    inc ren
    call redibujar
    jmp tecla

izquierda:
    call borrar
    cmp col, 0
    je tecla
    dec col
    call redibujar
    jmp tecla

derecha:
    call borrar
    cmp col, 79
    je tecla
    inc col
    call redibujar
    jmp tecla

borrar:
    ; Borrar carácter actual
    mov ah, 02h
    mov dh, ren
    mov dl, col
    mov bh, 0
    int 10h
    mov ah, 09h
    mov al, ' '
    mov bl, 0BBh
    mov cx, 1
    int 10h
    ret

redibujar:
    ; Dibujar carácter nuevo
    mov ah, 02h
    mov dh, ren
    mov dl, col
    mov bh, 0
    int 10h
    mov ah, 09h
    mov al, ' '
    mov bl, 44h
    mov cx, 1
    int 10h
    ret

end inicio