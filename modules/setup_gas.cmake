include(${SOURCE_ROOT_DIR}/modules/default_proj.cmake)
default_exec(GAS_EXEC "${GAS_EXEC}" "as")
set(CMAKE_GAS_COMPILER "${GAS_EXEC}")
set(CMAKE_GAS_COMPILER_ENV_VAR "")
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)