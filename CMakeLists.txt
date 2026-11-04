cmake_minimum_required(VERSION 3.25)

project(J3_ESC_Brushed LANGUAGES C ASM)

# ---------------------------------------------------------------------------
# Caminhos do projeto
# ---------------------------------------------------------------------------
set(PROJ_DIR      "${CMAKE_CURRENT_SOURCE_DIR}/firmware")
set(IBUS_DIR      "${CMAKE_CURRENT_SOURCE_DIR}/libs_github/iBus_FlySky")
set(LIB_DIR       "${IBUS_DIR}/CubeIDE/J3_ibus_flysky/Lib/j3_ibus_flysky")
set(HAL_DIR       "${PROJ_DIR}/Drivers/STM32F1xx_HAL_Driver")
set(CMSIS_DIR     "${PROJ_DIR}/Drivers/CMSIS")

# ---------------------------------------------------------------------------
# Alvo: STM32F103C8T6 (Cortex-M3, 64 KB Flash, 20 KB RAM)
# ---------------------------------------------------------------------------
set(MCU_FLAGS -mcpu=cortex-m3 -mthumb)
set(MCU_DEFINES USE_HAL_DRIVER STM32F103xB)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

# compile_commands.json para clangd/IntelliSense
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_compile_options(
    ${MCU_FLAGS}
    -ffunction-sections
    -fdata-sections
    -Wall
    $<$<CONFIG:Debug>:-Og>
    $<$<CONFIG:Debug>:-g3>
    $<$<CONFIG:Release>:-Os>
)

add_compile_definitions(${MCU_DEFINES})

add_link_options(
    ${MCU_FLAGS}
    -T${PROJ_DIR}/STM32F103C8TX_FLASH.ld
    -Wl,--gc-sections
    -Wl,--no-warn-rwx-segments
    -Wl,-Map=${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.map,--cref
    -Wl,--print-memory-usage
    --specs=nano.specs
    --specs=nosys.specs
)

# ---------------------------------------------------------------------------
# HAL + CMSIS
# ---------------------------------------------------------------------------
set(HAL_SOURCES
    ${HAL_DIR}/Src/stm32f1xx_hal.c
    ${HAL_DIR}/Src/stm32f1xx_hal_cortex.c
    ${HAL_DIR}/Src/stm32f1xx_hal_dma.c
    ${HAL_DIR}/Src/stm32f1xx_hal_exti.c
    ${HAL_DIR}/Src/stm32f1xx_hal_flash.c
    ${HAL_DIR}/Src/stm32f1xx_hal_flash_ex.c
    ${HAL_DIR}/Src/stm32f1xx_hal_gpio.c
    ${HAL_DIR}/Src/stm32f1xx_hal_gpio_ex.c
    ${HAL_DIR}/Src/stm32f1xx_hal_pwr.c
    ${HAL_DIR}/Src/stm32f1xx_hal_rcc.c
    ${HAL_DIR}/Src/stm32f1xx_hal_rcc_ex.c
    ${HAL_DIR}/Src/stm32f1xx_hal_tim.c
    ${HAL_DIR}/Src/stm32f1xx_hal_tim_ex.c
    ${HAL_DIR}/Src/stm32f1xx_hal_uart.c
)

add_library(stm32f1xx_hal STATIC ${HAL_SOURCES})
target_include_directories(stm32f1xx_hal PUBLIC
    ${PROJ_DIR}/Core/Inc
    ${HAL_DIR}/Inc
    ${HAL_DIR}/Inc/Legacy
    ${CMSIS_DIR}/Device/ST/STM32F1xx/Include
    ${CMSIS_DIR}/Include
)

# ---------------------------------------------------------------------------
# Biblioteca J3 iBus FlySky (submodulo libs_github/iBus_FlySky)
# ---------------------------------------------------------------------------
if(NOT EXISTS "${LIB_DIR}/Inc/j3_ibus_flysky.h")
    message(FATAL_ERROR
        "Biblioteca iBUS nao encontrada em ${LIB_DIR}.\n"
        "Inicialize o submodulo com:\n"
        "  git submodule update --init --recursive")
endif()

file(GLOB LIB_SOURCES CONFIGURE_DEPENDS "${LIB_DIR}/Src/*.c")

add_library(j3_ibus_flysky STATIC ${LIB_SOURCES})
target_include_directories(j3_ibus_flysky PUBLIC ${LIB_DIR}/Inc)
target_link_libraries(j3_ibus_flysky PUBLIC stm32f1xx_hal)

# ---------------------------------------------------------------------------
# Firmware da aplicacao
# ---------------------------------------------------------------------------
file(GLOB_RECURSE APP_SOURCES CONFIGURE_DEPENDS "${PROJ_DIR}/Core/Src/*.c")

set(STARTUP_SOURCE "${PROJ_DIR}/Core/Startup/startup_stm32f103c8tx.s")
set_source_files_properties(${STARTUP_SOURCE} PROPERTIES LANGUAGE ASM)

add_executable(${PROJECT_NAME}
    ${APP_SOURCES}
    ${STARTUP_SOURCE}
)

target_include_directories(${PROJECT_NAME} PRIVATE
    ${PROJ_DIR}/Core/Inc
    ${PROJ_DIR}/Core/Inc/usr
)

target_link_libraries(${PROJECT_NAME} PRIVATE j3_ibus_flysky)

# O codigo gerado pelo CubeMX tem parametros nao usados de proposito.
target_compile_options(${PROJECT_NAME} PRIVATE -Wno-unused-parameter)

set_target_properties(${PROJECT_NAME} PROPERTIES SUFFIX ".elf")

# ---------------------------------------------------------------------------
# Pos-build: .hex, .bin e uso de memoria
# ---------------------------------------------------------------------------
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O ihex
            $<TARGET_FILE:${PROJECT_NAME}>
            ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.hex
    COMMAND ${CMAKE_OBJCOPY} -O binary
            $<TARGET_FILE:${PROJECT_NAME}>
            ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.bin
    COMMAND ${CMAKE_SIZE} $<TARGET_FILE:${PROJECT_NAME}>
    COMMENT "Gerando .hex/.bin e relatorio de tamanho"
)

# ---------------------------------------------------------------------------
# Gravacao via ST-Link (opcional)
#   - STM32_Programmer_CLI (STM32CubeProgrammer)
#   - OpenOCD como alternativa
# ---------------------------------------------------------------------------
find_program(STM32_PROGRAMMER_CLI
    NAMES STM32_Programmer_CLI
    HINTS "C:/Program Files/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin"
          "C:/Program Files (x86)/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin"
)

find_program(OPENOCD_EXECUTABLE NAMES openocd)

if(STM32_PROGRAMMER_CLI)
    add_custom_target(flash
        COMMAND "${STM32_PROGRAMMER_CLI}" -c port=SWD
                -w "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.hex"
                -v -rst
        DEPENDS ${PROJECT_NAME}
        USES_TERMINAL
        COMMENT "Gravando ${PROJECT_NAME}.hex via ST-Link (SWD)"
    )
elseif(OPENOCD_EXECUTABLE)
    add_custom_target(flash
        COMMAND "${OPENOCD_EXECUTABLE}"
                -f interface/stlink.cfg
                -f target/stm32f1x.cfg
                -c "program ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.elf verify reset exit"
        DEPENDS ${PROJECT_NAME}
        USES_TERMINAL
        COMMENT "Gravando ${PROJECT_NAME}.elf via OpenOCD"
    )
else()
    message(STATUS
        "STM32_Programmer_CLI/OpenOCD nao encontrados: target 'flash' desabilitado")
endif()
