# Toolchain CMake para ARM GNU (arm-none-eabi) - STM32F103C8T6
#
# Uso:
#   cmake --preset debug
#   cmake --preset debug -DARM_TOOLCHAIN_DIR="C:/caminho/para/bin"
#
# A variavel de ambiente ARM_TOOLCHAIN_DIR tambem e aceita.

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

# Evita tentar linkar um executavel durante o teste do compilador.
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(ARM_TOOLCHAIN_DIR "" CACHE PATH "Diretorio bin do ARM GNU Toolchain")

find_program(ARM_NONE_EABI_GCC
    NAMES arm-none-eabi-gcc
    HINTS "${ARM_TOOLCHAIN_DIR}" "$ENV{ARM_TOOLCHAIN_DIR}"
)

if(NOT ARM_NONE_EABI_GCC)
    file(GLOB _arm_gcc_candidates
        "C:/Program Files/Arm GNU Toolchain arm-none-eabi/*/bin/arm-none-eabi-gcc.exe"
        "C:/Program Files (x86)/Arm GNU Toolchain arm-none-eabi/*/bin/arm-none-eabi-gcc.exe"
        "$ENV{LOCALAPPDATA}/Programs/Arm GNU Toolchain arm-none-eabi/*/bin/arm-none-eabi-gcc.exe"
    )
    if(_arm_gcc_candidates)
        list(SORT _arm_gcc_candidates)
        list(REVERSE _arm_gcc_candidates)
        list(GET _arm_gcc_candidates 0 ARM_NONE_EABI_GCC)
    endif()
endif()

if(NOT ARM_NONE_EABI_GCC)
    message(FATAL_ERROR
        "arm-none-eabi-gcc nao encontrado.\n"
        "Instale o ARM GNU Toolchain ou informe o diretorio bin com "
        "-DARM_TOOLCHAIN_DIR=... ou pela variavel de ambiente ARM_TOOLCHAIN_DIR.")
endif()

get_filename_component(ARM_TOOLCHAIN_BIN "${ARM_NONE_EABI_GCC}" DIRECTORY)

find_program(ARM_NONE_EABI_OBJCOPY NAMES arm-none-eabi-objcopy HINTS "${ARM_TOOLCHAIN_BIN}")
find_program(ARM_NONE_EABI_SIZE    NAMES arm-none-eabi-size    HINTS "${ARM_TOOLCHAIN_BIN}")
find_program(ARM_NONE_EABI_AR      NAMES arm-none-eabi-ar      HINTS "${ARM_TOOLCHAIN_BIN}")
find_program(ARM_NONE_EABI_RANLIB  NAMES arm-none-eabi-ranlib  HINTS "${ARM_TOOLCHAIN_BIN}")

set(CMAKE_C_COMPILER   "${ARM_NONE_EABI_GCC}" CACHE FILEPATH "")
set(CMAKE_ASM_COMPILER "${ARM_NONE_EABI_GCC}" CACHE FILEPATH "")
set(CMAKE_OBJCOPY      "${ARM_NONE_EABI_OBJCOPY}" CACHE FILEPATH "")
set(CMAKE_SIZE         "${ARM_NONE_EABI_SIZE}"    CACHE FILEPATH "")
set(CMAKE_AR           "${ARM_NONE_EABI_AR}"      CACHE FILEPATH "")
set(CMAKE_RANLIB       "${ARM_NONE_EABI_RANLIB}"  CACHE FILEPATH "")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
