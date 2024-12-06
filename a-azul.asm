.386
.model flat, stdcall
.stack 4096

include kernel32.inc
includelib kernel32.lib

ExitProcess proto :dword
SetConsoleCursorPosition proto :dword, :dword
SetConsoleTextAttribute proto :dword, :dword
WriteConsole proto :dword, :dword, :dword, :dword, :dword
ReadConsole proto :dword, :dword, :dword, :dword, :dword
GetStdHandle proto :dword

COORD struct
    X sword ?
    Y sword ?
COORD ends

.data
INVALID_HANDLE_VALUE equ -1
charText db 10 dup('A'), 0
textLength dd 10
cursorPos COORD <10, 10>
stdoutHandle dd ?
stdinHandle dd ?                
inputBuffer db 16 dup(?)         
bytesRead dd 0                  
charsWritten dd ?          

.code
main proc
    invoke GetStdHandle, -11
    cmp eax, INVALID_HANDLE_VALUE
    je exit_error
    mov stdoutHandle, eax

    mov eax, cursorPos
    invoke SetConsoleCursorPosition, stdoutHandle, eax


    invoke SetConsoleTextAttribute, stdoutHandle, 1Fh

    invoke WriteConsole, stdoutHandle, offset charText, textLength, offset charsWritten, 0

    invoke GetStdHandle, -10
    mov stdinHandle, eax

    invoke ReadConsole, stdinHandle, offset inputBuffer, sizeof inputBuffer, offset bytesRead, 0

    invoke ExitProcess, 0

exit_error:
    invoke ExitProcess, 1
main endp

end main
