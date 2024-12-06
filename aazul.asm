.386 
.model flat, stdcall ;model flat porque es para 32 bits
.stack 4096 ;la dirección en la que inicia la pila es la 4096

include kernel32.inc ;archivos de windows necesarios para ejecución
includelib kernel32.lib ;archivos de windows necesarios para ejecución

;estos son los métodos que se utilizan y defines cómo llamarlos (tamaño del parámetro)
;prácticamente es la sintaxis de comandos de la consola
ExitProcess proto :dword
SetConsoleCursorPosition proto :dword, :dword
WriteConsole proto :dword, :dword, :dword, :dword, :dword
GetStdHandle proto :dword

;estructura de coordenadas requerida para la variable que se pasará al 
;SetConsoleCursorPosition, es requisito que sea así
COORD struct
    X dw ?
    Y dw ?
COORD ends

.data
;bloque de declaración
INVALID_HANDLE_VALUE equ -1 ;definición de la salida de error del handle
;de aquí para abajo entiendo cada variable y su valor, pero no con exactitud los tamaños
;me parece que por requisito
charText db "A", 0                ; Carácter a imprimir
textLength dd 1                  ; Longitud del texto
cursorPos COORD <10, 10>          ; Nueva posición del cursor (10,10)
stdoutHandle dd ?                ; Handle de la consola

.code
main proc
    ; Obtener el handle de la consola de salida
    ;se llama la función y recibe el búfer de pantalla activo en la consola (qué es?, no sé)
    invoke GetStdHandle, -11
    ;guarda el valor en eax
    
    ;compara que no se haya recibido un error, desconozco si funcione jaj
    cmp eax, INVALID_HANDLE_VALUE
    ;manda a la salida si falla
    je exit_error                 ; Salir si falla
    ;guarda el valor del handle en la variable stdoutHandle
    mov stdoutHandle, eax         ; Guardar el handle

    ; manda a llamar la función para posicionar en pantalla con el handle guardado y 
    ;según la posición, pero es lo que no me funciona
    invoke SetConsoleCursorPosition, stdoutHandle, offset cursorPos

    ; manda a llamar la función, se pasa el handle, la dirección en memoria del char, 
    ; el número de caracteres que se imprimirán y otros dos parámetros que chequé en 
    ; la documentación pero no entendí del todo
    invoke WriteConsole, stdoutHandle, offset charText, textLength, 0, 0

	  ; finaliza la ejecución del programa
	  ; no sé por qué va el cero
    ; Salir del programa
    invoke ExitProcess, 0

exit_error:
	  ; finaliza la ejecución del programa
	  ; no sé por qué va el uno
    invoke ExitProcess, 1
main endp

end main
