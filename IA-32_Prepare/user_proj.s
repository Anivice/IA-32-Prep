.code16
.global _start

.text
.align 16
.section section.header
    .word section.header.end
    .word code_entry
    .word program_len
section.header.end:

.align 16
.section section.print.start
.equ code_entry, .
_start:
    # set ds = 0x07c0, es = 0xB800
    mov     $0x07C0,    %ax
    mov     %ax,        %ds
    mov     $0xB800,    %ax
    mov     %ax,        %es

    mov     $msg,       %si
    mov     $0x00,      %di
    mov     $msg_len,   %cx

_show_msg:
    mov     (%si),      %al
    mov     %al,        %es:(%di)
    inc     %di
    movb    $0x70,      %es:(%di)
    inc     %di
    inc     %si
    loop    _show_msg

    ret

msg:
    .ascii "Hello, world!"
    .equ msg_len, . - msg

.equ program_len, . - _start
