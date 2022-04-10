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

.code16
.global _start
.equ app_lba_start, 100 # user application start sector

.align 16
.section mbr
.word 0xFF


.align 16
.section mbr2
.word 0xFF
loc:
    jmp loc

.align 16
.section mbr3
.word 0xFF

.org 510
boot_flag:
    .word 0xAA55

