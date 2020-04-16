################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
LD_SRCS += \
../src/lscript.ld 

C_SRCS += \
../src/bloodtest_data.c \
../src/dvd_firmware.c \
../src/init.c \
../src/oi_ui.c \
../src/pages.c \
../src/platform.c \
../src/scientific_plot.c \
../src/sd_io.c \
../src/video_demo.c 

OBJS += \
./src/bloodtest_data.o \
./src/dvd_firmware.o \
./src/init.o \
./src/oi_ui.o \
./src/pages.o \
./src/platform.o \
./src/scientific_plot.o \
./src/sd_io.o \
./src/video_demo.o 

C_DEPS += \
./src/bloodtest_data.d \
./src/dvd_firmware.d \
./src/init.d \
./src/oi_ui.d \
./src/pages.d \
./src/platform.d \
./src/scientific_plot.d \
./src/sd_io.d \
./src/video_demo.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc compiler'
	arm-none-eabi-gcc -Wall -O2 -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -IC:/Users/nc1220/xilinx_workspace/dvd_firmware/dvd_firmware.sdk/def/export/def/sw/def/standalone_domain/bspinclude/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


