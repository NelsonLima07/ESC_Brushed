@echo off
REM ---------------------------------------------------------------------------
REM build.bat - Compila o firmware J3_ESC_Brushed com CMake + Ninja
REM
REM Uso:
REM   build.bat                  Compila o preset debug (padrao)
REM   build.bat release          Compila o preset release
REM   build.bat all              Compila debug e release
REM   build.bat clean            Limpa o build antes de compilar
REM   build.bat flash            Compila e grava na placa via ST-Link
REM   build.bat release flash    Compila release e grava na placa
REM ---------------------------------------------------------------------------

setlocal
pushd "%~dp0" >nul

set "PRESET=debug"
set "CLEAN=0"
set "FLASH=0"

:parse
if "%~1"=="" goto check_tools
if /i "%~1"=="debug"   goto arg_debug
if /i "%~1"=="release" goto arg_release
if /i "%~1"=="all"     goto arg_all
if /i "%~1"=="clean"   goto arg_clean
if /i "%~1"=="flash"   goto arg_flash
if /i "%~1"=="-h"      goto usage
if /i "%~1"=="--help"  goto usage
if /i "%~1"=="/?"      goto usage
echo [ERRO] Argumento desconhecido: %~1
set "BADARG=1"
goto usage

:arg_debug
set "PRESET=debug"
shift
goto parse

:arg_release
set "PRESET=release"
shift
goto parse

:arg_all
set "PRESET=all"
shift
goto parse

:arg_clean
set "CLEAN=1"
shift
goto parse

:arg_flash
set "FLASH=1"
shift
goto parse

:check_tools
REM O winget instala o toolchain fora do PATH de sessoes ja abertas.
where arm-none-eabi-gcc >nul 2>&1
if not errorlevel 1 goto toolchain_ok

set "ARM_BIN="
for /d %%D in ("C:\Program Files (x86)\Arm GNU Toolchain arm-none-eabi\*") do if not defined ARM_BIN set "ARM_BIN=%%~fD\bin"
if not defined ARM_BIN for /d %%D in ("C:\Program Files\Arm GNU Toolchain arm-none-eabi\*") do if not defined ARM_BIN set "ARM_BIN=%%~fD\bin"
if not defined ARM_BIN for /d %%D in ("%LOCALAPPDATA%\Programs\Arm GNU Toolchain arm-none-eabi\*") do if not defined ARM_BIN set "ARM_BIN=%%~fD\bin"
if defined ARM_BIN set "PATH=%ARM_BIN%;%PATH%"

:toolchain_ok
where arm-none-eabi-gcc >nul 2>&1
if errorlevel 1 (
    echo [ERRO] arm-none-eabi-gcc nao encontrado.
    echo        Instale com: winget install --id Arm.GnuArmEmbeddedToolchain -e
    echo        Ou informe o diretorio bin em: set ARM_TOOLCHAIN_DIR=C:\caminho\bin
    goto fail
)

where cmake >nul 2>&1
if errorlevel 1 (
    echo [ERRO] cmake nao encontrado.
    echo        Instale com: winget install --id Kitware.CMake -e
    goto fail
)

where ninja >nul 2>&1
if errorlevel 1 (
    echo [ERRO] ninja nao encontrado.
    echo        Instale com: winget install --id Ninja-build.Ninja -e
    goto fail
)

if not exist "libs_github\iBus_FlySky\CubeIDE\J3_ibus_flysky\Lib\j3_ibus_flysky\Inc\j3_ibus_flysky.h" (
    echo [ERRO] Submodulo iBus_FlySky nao inicializado.
    echo        Rode: git submodule update --init --recursive
    goto fail
)

if not "%FLASH%"=="1" goto flash_ok
where STM32_Programmer_CLI >nul 2>&1
if not errorlevel 1 goto flash_ok
where openocd >nul 2>&1
if not errorlevel 1 goto flash_ok
if exist "C:\Program Files\STMicroelectronics\STM32Cube\STM32CubeProgrammer\bin\STM32_Programmer_CLI.exe" goto flash_ok
if exist "C:\Program Files (x86)\STMicroelectronics\STM32Cube\STM32CubeProgrammer\bin\STM32_Programmer_CLI.exe" goto flash_ok
echo [ERRO] STM32_Programmer_CLI/OpenOCD nao encontrado.
echo        Instale o STM32CubeProgrammer (ou OpenOCD) para usar o target flash.
goto fail

:flash_ok
if /i "%PRESET%"=="all" goto build_all
call :build_one %PRESET%
if errorlevel 1 goto fail
goto done

:build_all
call :build_one debug
if errorlevel 1 goto fail
call :build_one release
if errorlevel 1 goto fail
goto done

REM ---------------------------------------------------------------------------
REM :build_one <preset>
REM ---------------------------------------------------------------------------
:build_one
setlocal
set "P=%~1"

if "%CLEAN%"=="1" (
    if exist "build\%P%" (
        echo [INFO] Limpando build\%P% ...
        rmdir /s /q "build\%P%"
    )
)

echo.
echo [1/2] Configurando preset %P% ...
cmake --preset %P%
if errorlevel 1 (
    echo [ERRO] Falha na configuracao do preset %P%.
    endlocal
    exit /b 1
)

echo.
echo [2/2] Compilando preset %P% ...
if "%FLASH%"=="1" (
    cmake --build --preset %P% --target flash
) else (
    cmake --build --preset %P%
)
if errorlevel 1 (
    echo [ERRO] Falha na compilacao do preset %P%.
    endlocal
    exit /b 1
)

echo.
echo [OK] %P%: build\%P%\J3_ESC_Brushed.elf
endlocal
exit /b 0

:usage
echo.
echo Uso: build.bat [debug^|release^|all] [clean] [flash]
echo.
echo   debug     Compila o preset debug (padrao)
echo   release   Compila o preset release
echo   all       Compila debug e release
echo   clean     Remove build^<preset^> antes de compilar
echo   flash     Compila e grava na placa via ST-Link (SWD)
echo.
echo Exemplos:
echo   build.bat
echo   build.bat release
echo   build.bat clean
echo   build.bat release flash
if "%BADARG%"=="1" goto fail
popd >nul
endlocal
exit /b 0

:fail
popd >nul
endlocal
exit /b 1

:done
echo.
echo [OK] Build concluido.
popd >nul
endlocal
exit /b 0
