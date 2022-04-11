/*
.section name[, "flags"]
.section name[, subsegment]
    If the optional argument is quoted, it is taken as flags to use for the section.
    Each flag is a single character. The following flags are recognized:

    b
        bss section (uninitialized data)
    n
        section is not loaded
    w
        writable section
    d
        data section
    r
        read-only section
    x
        executable section

.section name[, "flags"[, @type]]
    The optional flags argument is a quoted string which may contain any combintion of the following characters:

    a
        section is allocatable
    w
        section is writable
    x
        section is executable

    The optional type argument may contain one of the following constants:

    @progbits
        section contains data
    @nobits
        section does not contain data (i.e., section only occupies space)

    If no flags are specified, the default flags depend upon the section name. If the section name is not recognized,
    the default will be for the section to have none of the above flags:
    it will not be allocated in memory, nor writable, nor executable. The section will contain data.

    For ELF targets, the assembler supports another type of .section directive for
    compatibility with the Solaris assembler:

.section "name"[, flags...]
    Note that the section name is quoted. There may be a sequence of comma separated flags:

    #alloc
        section is allocatable
    #write
        section is writable
    #execinstr
        section is executable
*/

/*
    Read disk sector
*/

.code16
.global _start
.equ app_lba_start, 1   # user application start sector
.equ target_proj_address, 0x10000  # location where program is ganna loaded to
.org 0x00
.align 16
_start:

    # setup stack frame
    mov     $0x00,      %ax
    mov     %ax,        %ss
    mov     %ax,        %sp

    mov     $0xB800,    %ax
    mov     %ax,        %ds
    mov     %ax,        %es

    # set read sector count (0x01)
    mov     $0x1F2,     %dx
    mov     $0x01,      %al
    out     %al,        (%dx)

    # setup LBA28
    mov     $0x1F3,     %dx
    mov     $0x01,      %al
    out     %al,        (%dx)   # logic sector num 7 - 0

    inc     %dx
    mov     $0x00,      %al
    out     %al,        (%dx)   # logic sector num 15 - 8

    inc     %dx
    out     %al,        (%dx)   # logic sector num 23 - 16

    inc     %dx
    mov     $0xE0,      %al
    out     %al,        (%dx)   # logic sector num (lower 4) 27 - 24

    # request reading
    mov     $0x1F7,     %dx
    mov     $0x20,      %al
    out     %al,        (%dx)


    # wait for operation to finish
.wait:
    in      (%dx),      %al
    and     $0x88,      %al
    cmp     $0x08,      %al
    jnz     .wait


    # read data (512 bytes)
    mov     $256,       %cx
    mov     $0x1f0,     %dx
    mov     $0x00,      %bx
.read:
    in      (%dx),      %ax
    mov     %ax,        (%bx)
    add     $2,         %bx
    loop    .read

    jmp     .

.org 510
boot_flag:
    .word 0xAA55
