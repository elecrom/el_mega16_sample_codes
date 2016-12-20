################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include subdir.mk
-include FreeRTOS/Source/subdir.mk
-include FreeRTOS/Source/portable/MemMang/subdir.mk
-include FreeRTOS/Source/portable/GCC/ATMega323/subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(ASM_DEPS)),)
-include $(ASM_DEPS)
endif
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
LSS += \
FreeRTOS_m16_demo.lss \

FLASH_IMAGE += \
FreeRTOS_m16_demo.hex \

EEPROM_IMAGE += \
FreeRTOS_m16_demo.eep \

SIZEDUMMY += \
sizedummy \


# All Target
all: FreeRTOS_m16_demo.elf secondary-outputs

# Tool invocations
FreeRTOS_m16_demo.elf: $(OBJS) $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: AVR C Linker'
	avr-gcc -Wl,-Map,FreeRTOS_m16_demo.map -mmcu=atmega16 -o"FreeRTOS_m16_demo.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '

FreeRTOS_m16_demo.lss: FreeRTOS_m16_demo.elf
	@echo 'Invoking: AVR Create Extended Listing'
	-avr-objdump -h -S FreeRTOS_m16_demo.elf  >"FreeRTOS_m16_demo.lss"
	@echo 'Finished building: $@'
	@echo ' '

FreeRTOS_m16_demo.hex: FreeRTOS_m16_demo.elf
	@echo 'Create Flash image (ihex format)'
	-avr-objcopy -R .eeprom -O ihex FreeRTOS_m16_demo.elf  "FreeRTOS_m16_demo.hex"
	@echo 'Finished building: $@'
	@echo ' '

FreeRTOS_m16_demo.eep: FreeRTOS_m16_demo.elf
	@echo 'Create eeprom image (ihex format)'
	-avr-objcopy -j .eeprom --no-change-warnings --change-section-lma .eeprom=0 -O ihex FreeRTOS_m16_demo.elf  "FreeRTOS_m16_demo.eep"
	@echo 'Finished building: $@'
	@echo ' '

sizedummy: FreeRTOS_m16_demo.elf
	@echo 'Invoking: Print Size'
	-avr-size --format=avr --mcu=atmega16 FreeRTOS_m16_demo.elf
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(OBJS)$(C_DEPS)$(ASM_DEPS)$(EEPROM_IMAGE)$(FLASH_IMAGE)$(ELFS)$(LSS)$(S_DEPS)$(SIZEDUMMY)$(S_UPPER_DEPS) FreeRTOS_m16_demo.elf
	-@echo ' '

secondary-outputs: $(LSS) $(FLASH_IMAGE) $(EEPROM_IMAGE) $(SIZEDUMMY)

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
