ORG 0x7c0
BITS 16 ; tell assembler were using 16 bit architecture

CODE_SEG equ gdt_code_seg - gdt_start
DATA_SEG equ gdt_data - start
_start:
    jmp short start
    nop

times 33 db 0

start:
    jmp 0:s2

s2:
    cli
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti



.load_prot:
    cli
    lgdt[gdt_desc]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp CODE_SEG:load32


gdt_start:


gdt_null:
    dd 0x0
    dd 0x0
gdt_code_seg:
    dw 0xffff
    dw 0
    db 0
    db 0x9a
    db 11001111b
    db 0

gdt_data:
    dw 0xffff
    dw 0
    db 0
    db 0x92
    db 1100111b
    db 0 

gdt_end:
    

gdt_desc:
    dw gdt_end - gdt_start - 1
    dd gdt_start

[BITS 32] ; tell asembler were in 32 bit land
load32:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov ebp, 0x00200000
    mov esp, ebp

    in al, 0x92
    or al, 2
    out 0x92, al

    jmp $ 


times 510- ($ - $$) db 0 ; pad extra dat with 0
dw 0xAA55 ; boot signiture

buffer: