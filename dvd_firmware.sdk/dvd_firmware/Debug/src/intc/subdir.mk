################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/intc/intc.c 

OBJS += \
./src/intc/intc.o 

C_DEPS += \
./src/intc/intc.d 


# Each subdirectory must supply rules for building sources it contributes
src/intc/%.o: ../src/intc/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc compiler'
	arm-none-eabi-gcc -Wall -O2 -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -IC:/Users/nc1220/xilinx_workspace/dvd_firmware/dvd_firmware.sdk/def/export/def/sw/def/standalone_domain/bspinclude/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


