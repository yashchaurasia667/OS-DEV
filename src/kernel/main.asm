org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

start:
    jmp main

;
;   Prints a string to the screen
;   Params:
;       - ds:si points to string
;

puts:
    ; save registers we will modify
    push si
    push ax
    push bx

.loop:
    lodsb                   ;   loads the next character in al
    or al, al               ;   verify if next chararcter is null
    jz .done

    mov ah, 0x0e            ;   calls BIOS interrupt
    mov bh, 0               ;   sets page number to 0
    int 0x10

    jmp .loop

.done:
    pop bx
    pop ax
    pop si
    ret

main:
    ; setup data segments
    mov ax, 0               ;   can't set ds/es directly
    mov ds, ax
    mov es, ax

    ;setup stack
    mov ss, ax
    mov sp, 0x7C00          ;   stack grows downward from where we are loaded in the memory 

    ; print hello world message
    mov si, msg
    call puts

    hlt

.halt:
    jmp .halt

msg: db 'Hello, World!', ENDL, 0

times 510-($-$$) db 0
dw 0AA55h