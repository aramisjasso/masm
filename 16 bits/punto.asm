.model small
.stack 100h

.code
start:
    ; Cambiar al modo gráfico 13h (320x200, 256 colores)
    mov ax, 0013h
    int 10h

    ; Dibujar un punto en el centro de la pantalla
    mov cx, 160     ; Coordenada X (centro de 320)
    mov dx, 100     ; Coordenada Y (centro de 200)
    mov al, 4       ; Color rojo (en la paleta VGA, 4 es rojo)
    mov ah, 0Ch     ; Función para dibujar un píxel
    int 10h

    ; Esperar a que el usuario presione una tecla
    mov ah, 00h
    int 16h

    ; Regresar al modo de texto
    mov ax, 0003h
    int 10h

    ret
end start
