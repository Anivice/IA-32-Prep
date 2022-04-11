cmake_minimum_required(VERSION 3.17)

# setup gas
LIST(APPEND CMAKE_MODULE_PATH "${SOURCE_ROOT_DIR}/modules")
include("${SOURCE_ROOT_DIR}/modules/setup_gas.cmake")

project(boot ASM_AS)

function(add_single_file diskname need_qemu vstart)
    # Compile boot sector
    set_source_files_properties(${diskname}.s PROPERTIES LANGUAGE ASM_AS)
    add_executable(${diskname} ${diskname}.s)
    target_compile_options(${diskname} PUBLIC --32 -g)
    target_link_options(${diskname} PUBLIC -Ttext ${vstart} -m elf_i386 -g)

    # strip boot sector
    add_custom_target(strip_${diskname} ALL
            # Make a copy of current object
            COMMAND ${SOURCE_ROOT_DIR}/script/strip_bootsect.sh
                    32bit_real_mode/${diskname} ${OBJCPY_EXEC} ${DD_EXEC} ${RM_EXEC} ${GLD_EXEC}
            DEPENDS ${diskname}
            WORKING_DIRECTORY ${BINARY_ROOT_DIR})

    if (${need_qemu})
        # add QEMU boot
        add_custom_target(qemu_boot_${diskname}
                ${QEMU_EXEC} -drive file=32bit_real_mode/${diskname}.bin,format=raw,index=0,media=disk -m 16M
                DEPENDS strip_${diskname}
                WORKING_DIRECTORY ${BINARY_ROOT_DIR})
    endif(${need_qemu})

endfunction()

add_single_file(simple_bootsect     TRUE    0x0000)
add_single_file(advanced_bootsect   TRUE    0x0000)
add_single_file("1+2+...+100"       TRUE    0x0000)
add_single_file(sections            FALSE   0x0000)

# setup NASM, so that NASM can build a pure binary data out of a single file
set(CMAKE_ASM_NASM_OBJECT_FORMAT bin)
set(CMAKE_ASM_NASM_LINK_EXECUTABLE "${CP_EXEC} <OBJECTS> <TARGET>")
enable_language(ASM_NASM)
if(CMAKE_ASM_NASM_COMPILER_LOADED)
    set(CAN_USE_ASSEMBLER TRUE)
endif(CMAKE_ASM_NASM_COMPILER_LOADED)
set_source_files_properties(user_proj.asm PROPERTIES LANGUAGE ASM_NASM)
add_executable(user_proj user_proj.asm)

add_custom_target(make_section_boot_disk ALL
        COMMAND ${CP_EXEC} 32bit_real_mode/sections.bin 32bit_real_mode/disk
        #COMMAND ${DD_EXEC} if=32bit_real_mode/user_proj of=32bit_real_mode/disk
        #                   oflag=append conv=notrunc 2> /dev/null > /dev/null
        COMMAND echo "Hpeplplpop,pWpoprplpdp!p p" >> 32bit_real_mode/disk
        COMMAND ${DD_EXEC} if=/dev/zero of=32bit_real_mode/disk oflag=append conv=notrunc bs=485 count=1
        DEPENDS user_proj strip_sections
        BYPRODUCTS ${BINARY_ROOT_DIR}/32bit_real_mode/disk
        WORKING_DIRECTORY ${BINARY_ROOT_DIR})

add_custom_target(section_boot
        ${QEMU_EXEC} -drive file=32bit_real_mode/disk,format=raw,index=0,media=disk -m 16M
        DEPENDS make_section_boot_disk
        WORKING_DIRECTORY ${BINARY_ROOT_DIR})
