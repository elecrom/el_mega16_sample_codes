################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../FreeRTOS/Source/croutine.c \
../FreeRTOS/Source/list.c \
../FreeRTOS/Source/queue.c \
../FreeRTOS/Source/tasks.c 

OBJS += \
./FreeRTOS/Source/croutine.o \
./FreeRTOS/Source/list.o \
./FreeRTOS/Source/queue.o \
./FreeRTOS/Source/tasks.o 

C_DEPS += \
./FreeRTOS/Source/croutine.d \
./FreeRTOS/Source/list.d \
./FreeRTOS/Source/queue.d \
./FreeRTOS/Source/tasks.d 


# Each subdirectory must supply rules for building sources it contributes
FreeRTOS/Source/%.o: ../FreeRTOS/Source/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: AVR Compiler'
	avr-gcc -I"D:\mega16_kitCD\sample code\ex10_FreeRTOS_LEDBlink_WinAVR\FreeRTOS_m16_demo\FreeRTOS\Source\include" -I"D:\mega16_kitCD\sample code\ex10_FreeRTOS_LEDBlink_WinAVR\FreeRTOS_m16_demo\FreeRTOS\Source\portable\GCC\ATMega323" -I"D:\mega16_kitCD\sample code\ex10_FreeRTOS_LEDBlink_WinAVR\FreeRTOS_m16_demo\FreeRTOS\Source\portable\MemMang" -I"D:\mega16_kitCD\sample code\ex10_FreeRTOS_LEDBlink_WinAVR\FreeRTOS_m16_demo" -DGCC_MEGA_AVR -Wall -O3 -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -mmcu=atmega16 -DF_CPU=16000000UL -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -c -o"$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


