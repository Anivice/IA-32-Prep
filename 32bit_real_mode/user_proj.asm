org 0x00

;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; HEAD ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;
SECTION header align=16 vstart=0
    segmentation.length             dd      program.end                 ; 0x00000160
    section.print.segmentation      dd      section.print.start         ; 0x00000020

    segmentation.list.size          dw      (segmentation_table_end - segmentation_table_start) / 4 ; 0x0002
segmentation_table_start:
    print.segment                   dd      section.print.start         ; 0x00000020
    stackframe.segment              dd      section.stackframe.start    ; 0x00000060
segmentation_table_end:
header.end:


;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; PRINT ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;
SECTION print align=16 vstart=0
my_text     db   'H', 0x70, 'e', 0x70, 'l', 0x70, 'l', 0x70, 'o', 0x70, ',', 0x70, ' ', 0x70, \
                 'w', 0x70, 'o', 0x70, 'r', 0x70, 'l', 0x70, 'd', 0x70, '!', 0x70
my_text_len equ $ - my_text

print.entry:
    mov     ax,         0x7c0
    mov     ds,         ax
    mov     ax,         0xB800
    mov     es,         ax

    cld 
    mov     si,         my_text
    mov     di,         0x00
    mov     cx,         my_text_len
    rep movsb
    ret
print.end:


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; STACK FRAME ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION stackframe align=16 vstart=0
    db 256 dup(0)
    ;resb 256
stackframe.end:

;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; END ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;
SECTION trail align=16
program.end:
