################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/lvgl/lv_draw/lv_draw.c \
../src/lvgl/lv_draw/lv_draw_arc.c \
../src/lvgl/lv_draw/lv_draw_img.c \
../src/lvgl/lv_draw/lv_draw_label.c \
../src/lvgl/lv_draw/lv_draw_line.c \
../src/lvgl/lv_draw/lv_draw_rbasic.c \
../src/lvgl/lv_draw/lv_draw_rect.c \
../src/lvgl/lv_draw/lv_draw_triangle.c \
../src/lvgl/lv_draw/lv_draw_vbasic.c 

OBJS += \
./src/lvgl/lv_draw/lv_draw.o \
./src/lvgl/lv_draw/lv_draw_arc.o \
./src/lvgl/lv_draw/lv_draw_img.o \
./src/lvgl/lv_draw/lv_draw_label.o \
./src/lvgl/lv_draw/lv_draw_line.o \
./src/lvgl/lv_draw/lv_draw_rbasic.o \
./src/lvgl/lv_draw/lv_draw_rect.o \
./src/lvgl/lv_draw/lv_draw_triangle.o \
./src/lvgl/lv_draw/lv_draw_vbasic.o 

C_DEPS += \
./src/lvgl/lv_draw/lv_draw.d \
./src/lvgl/lv_draw/lv_draw_arc.d \
./src/lvgl/lv_draw/lv_draw_img.d \
./src/lvgl/lv_draw/lv_draw_label.d \
./src/lvgl/lv_draw/lv_draw_line.d \
./src/lvgl/lv_draw/lv_draw_rbasic.d \
./src/lvgl/lv_draw/lv_draw_rect.d \
./src/lvgl/lv_draw/lv_draw_triangle.d \
./src/lvgl/lv_draw/lv_draw_vbasic.d 


# Each subdirectory must supply rules for building sources it contributes
src/lvgl/lv_draw/%.o: ../src/lvgl/lv_draw/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc compiler'
	arm-none-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -I../../dvd2_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


