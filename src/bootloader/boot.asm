org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

;
;   FAT12 header
;
;   The BIOS parameter block

jmp short start 
nop

;   OEM identifier
bdb_oem:                        db 'MSWIN4.1'       ;   8 bytes
bdb_bytes_per_sector:           dw 512
bdb_sectors_per_cluster:        db 1
bdb_reserved_sectors:           dw 1
bdb_fat_count:                  db 2
bdb_dir_entry_count:            dw 0E0h
bdb_total_sectors:              dw 2880             ;   2880 * 512 = 1.44 mb
bdb_media_descriptor_type:      db 0F0h             ;   F0 = 3.5 inch floppy disk
bdb_sectors_per_fat:            dw 9
bdb_sectors_per_track:          dw 18
bdb_heads:                      dw 2
bdb_hidden_sectors:             dd 0
bdb_large_sector_count:         dd 0

;   extended boot record
ebr_drive_number:               db 0                ;   0x00 = floppy, 0x80 = hdd
                                db 0                ;   reserved byte
ebr_signature:                  db 29h
ebr_volume_id:                  db 12h, 54h, 67h, 89h   ;   serial number
ebr_volume_label:               db 'BOOMBOOM OS'    ;   11 bytes, padded with spaces
ebr_system_id:                  db 'FAT12   '       ;   8 bytes

;
;   Code goes here
;


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