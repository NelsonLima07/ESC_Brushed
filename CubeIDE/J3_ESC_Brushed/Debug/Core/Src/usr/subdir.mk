################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (10.3-2021.10)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Src/usr/J3_IBUS_FLYSKY.c \
../Core/Src/usr/J3_PonteH.c \
../Core/Src/usr/main_ESC_Brushed.c 

OBJS += \
./Core/Src/usr/J3_IBUS_FLYSKY.o \
./Core/Src/usr/J3_PonteH.o \
./Core/Src/usr/main_ESC_Brushed.o 

C_DEPS += \
./Core/Src/usr/J3_IBUS_FLYSKY.d \
./Core/Src/usr/J3_PonteH.d \
./Core/Src/usr/main_ESC_Brushed.d 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/usr/%.o Core/Src/usr/%.su: ../Core/Src/usr/%.c Core/Src/usr/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-usr

clean-Core-2f-Src-2f-usr:
	-$(RM) ./Core/Src/usr/J3_IBUS_FLYSKY.d ./Core/Src/usr/J3_IBUS_FLYSKY.o ./Core/Src/usr/J3_IBUS_FLYSKY.su ./Core/Src/usr/J3_PonteH.d ./Core/Src/usr/J3_PonteH.o ./Core/Src/usr/J3_PonteH.su ./Core/Src/usr/main_ESC_Brushed.d ./Core/Src/usr/main_ESC_Brushed.o ./Core/Src/usr/main_ESC_Brushed.su

.PHONY: clean-Core-2f-Src-2f-usr

