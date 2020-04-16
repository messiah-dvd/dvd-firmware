################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/dynclk/dynclk.c 

OBJS += \
./src/dynclk/dynclk.o 

C_DEPS += \
./src/dynclk/dynclk.d 


# Each subdirectory must supply rules for building sources it contributes
src/dynclk/%.o: ../src/dynclk/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc compiler'
	arm-none-eabi-gcc -Wall -O2 -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -IC:/Users/nc1220/xilinx_workspace/dvd_firmware/dvd_firmware.sdk/def/export/def/sw/def/standalone_domain/bspinclude/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


