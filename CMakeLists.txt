cmake_minimum_required(VERSION 3.17)

set(SOURCE_ROOT_DIR "${CMAKE_SOURCE_DIR}")
set(BINARY_ROOT_DIR "${CMAKE_BINARY_DIR}")
set(INCLUDE_DIR "${SOURCE_ROOT_DIR}/include")

################################
###### Default Executable ######
################################

include(modules/default_proj.cmake)

default_exec(QEMU_EXEC      "${QEMU_EXEC}"      "qemu-system-i386")
default_exec(DD_EXEC        "${DD_EXEC}"        "dd")
default_exec(CP_EXEC        "${CP_EXEC}"        "cp")
default_exec(GAS_EXEC       "${GAS_EXEC}"       "as")
default_exec(GLD_EXEC       "${GLD_EXEC}"       "ld")
default_exec(STRIP_EXEC     "${STRIP_EXEC}"     "strip")
default_exec(OBJCPY_EXEC    "${OBJCPY_EXEC}"    "objcopy")
default_exec(NM_EXEC        "${NM_EXEC}"        "nm")
default_exec(GREP_EXEC      "${GREP_EXEC}"      "grep")
default_exec(SORT_EXEC      "${SORT_EXEC}"      "sort")
default_exec(RM_EXEC        "${RM_EXEC}"        "rm")

default_flags(ADDITIONAL_QEMU_FLAG "${ADDITIONAL_QEMU_FLAG}"    "")
default_flags(GAS_FLAGS         "${GAS_FLAGS}"          "--32 -g")
default_flags(GAS_LDFLAGS       "${GAS_LDFLAGS}"        "-m elf_i386 -g")
default_flags(GCCFLAGS          "${GCCFLAGS}"           "-m32 -fno-builtin \
                                                         -fno-stack-protector \
                                                         -fomit-frame-pointer \
                                                         -fstrength-reduce -Wall -g")

string(REPLACE " " ";" ADDITIONAL_QEMU_FLAG    "${ADDITIONAL_QEMU_FLAG}")
string(REPLACE " " ";" GAS_FLAGS    "${GAS_FLAGS}")
string(REPLACE " " ";" GAS_LDFLAGS  "${GAS_LDFLAGS}")
string(REPLACE " " ";" GCCFLAGS     "${GCCFLAGS}")

################################
#########  Output Name #########
################################
default_flags(KERNEL_NAME "${KERNEL_NAME}" "linux")
default_flags(FLOPPY_IMG_NAME "${FLOPPY_IMG_NAME}" "floppy.img")

################################
###### Proj Configuration ######
################################

project(IA_32_Prep)

################################
####### Default Compilers ######
################################

# GCC 2.1 20201125 or higher is required for compile

if ((NOT ${CMAKE_C_COMPILER_ID} STREQUAL "GNU")
        OR
    (${CMAKE_C_COMPILER_VERSION} VERSION_LESS 10.2.1))
    message(FATAL_ERROR "This kernel can ONLY be compiled by GCC 10.2.1 20201125 or higher")
endif()

set(CMAKE_C_STANDARD 11)

#############################################
###### Preparation Knowledge for IA-32 ######
#############################################

add_subdirectory(IA-32_Prepare)
