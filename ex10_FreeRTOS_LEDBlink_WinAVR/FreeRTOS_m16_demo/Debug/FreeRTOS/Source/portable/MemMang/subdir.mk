################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../FreeRTOS/Source/portable/MemMang/heap_1.c \
../FreeRTOS/Source/portable/MemMang/heap_2.c \
../FreeRTOS/Source/portable/MemMang/heap_3.c 

OBJS += \
./FreeRTOS/Source/portable/MemMang/heap_1.o \
./FreeRTOS/Source/portable/MemMang/heap_2.o \
./FreeRTOS/Source/portable/MemMang/heap_3.o 

C_DEPS += \
./FreeRTOS/Source/portable/MemMang/heap_1.d \
./FreeRTOS/Source/portable/MemMang/heap_2.d \
./FreeRTOS/Source/portable/MemMang/heap_3.d 


# Each subdirectory must supply rules for building sources it contributes
FreeRTOS/Source/portable/MemMang/%.o: ../FreeRTOS/Source/portable/MemMang/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: AVR Compiler'
	avr-gcc -Wall -g2 -gstabs -O0 -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -mmcu=atmega16 -DF_CPU=1000000UL -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -c -o"$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


