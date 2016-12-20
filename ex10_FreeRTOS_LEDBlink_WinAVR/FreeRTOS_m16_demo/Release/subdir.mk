################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../main.c 

OBJS += \
./main.o 

C_DEPS += \
./main.d 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.c
	@echo 'Building file: $<'
	@echo 'Invoking: AVR Compiler'
	avr-gcc -I"D:\mega16_kitCD\sample code\ex10_FreeRTOS_LEDBlink_WinAVR\FreeRTOS_m16_demo\FreeRTOS\Source\include" -I"D:\mega16_kitCD\sample code\ex10_FreeRTOS_LEDBlink_WinAVR\FreeRTOS_m16_demo\FreeRTOS\Source\portable\GCC\ATMega323" -I"D:\mega16_kitCD\sample code\ex10_FreeRTOS_LEDBlink_WinAVR\FreeRTOS_m16_demo\FreeRTOS\Source\portable\MemMang" -I"D:\mega16_kitCD\sample code\ex10_FreeRTOS_LEDBlink_WinAVR\FreeRTOS_m16_demo" -DGCC_MEGA_AVR -Wall -O3 -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -mmcu=atmega16 -DF_CPU=16000000UL -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -c -o"$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


