################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/lvgl/lv_hal/lv_hal_disp.c \
../src/lvgl/lv_hal/lv_hal_indev.c \
../src/lvgl/lv_hal/lv_hal_tick.c 

OBJS += \
./src/lvgl/lv_hal/lv_hal_disp.o \
./src/lvgl/lv_hal/lv_hal_indev.o \
./src/lvgl/lv_hal/lv_hal_tick.o 

C_DEPS += \
./src/lvgl/lv_hal/lv_hal_disp.d \
./src/lvgl/lv_hal/lv_hal_indev.d \
./src/lvgl/lv_hal/lv_hal_tick.d 


# Each subdirectory must supply rules for building sources it contributes
src/lvgl/lv_hal/%.o: ../src/lvgl/lv_hal/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc compiler'
	arm-none-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -IC:/Users/nc1220/xilinx_workspace/dvd_firmware/def/export/def/sw/def/standalone_domain/bspinclude/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


