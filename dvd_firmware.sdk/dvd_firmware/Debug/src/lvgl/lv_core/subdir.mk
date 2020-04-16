################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/lvgl/lv_core/lv_group.c \
../src/lvgl/lv_core/lv_indev.c \
../src/lvgl/lv_core/lv_obj.c \
../src/lvgl/lv_core/lv_refr.c \
../src/lvgl/lv_core/lv_style.c \
../src/lvgl/lv_core/lv_vdb.c 

OBJS += \
./src/lvgl/lv_core/lv_group.o \
./src/lvgl/lv_core/lv_indev.o \
./src/lvgl/lv_core/lv_obj.o \
./src/lvgl/lv_core/lv_refr.o \
./src/lvgl/lv_core/lv_style.o \
./src/lvgl/lv_core/lv_vdb.o 

C_DEPS += \
./src/lvgl/lv_core/lv_group.d \
./src/lvgl/lv_core/lv_indev.d \
./src/lvgl/lv_core/lv_obj.d \
./src/lvgl/lv_core/lv_refr.d \
./src/lvgl/lv_core/lv_style.d \
./src/lvgl/lv_core/lv_vdb.d 


# Each subdirectory must supply rules for building sources it contributes
src/lvgl/lv_core/%.o: ../src/lvgl/lv_core/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc compiler'
	arm-none-eabi-gcc -Wall -O2 -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -IC:/Users/nc1220/xilinx_workspace/dvd_firmware/dvd_firmware.sdk/def/export/def/sw/def/standalone_domain/bspinclude/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


