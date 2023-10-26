##########
# Makefile
##########

# 目标
TARGET = app

# 生成路径
BUILD_DIR = build

# 编译优化
OPT = -Og
DEBUG = 1

# 编译器
PREFIX = riscv-none-elf-
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc
LD = $(PREFIX)gcc
OBJCOPY = $(PREFIX)objcopy
SIZE = $(PREFIX)size

HEX = $(OBJCOPY) -O ihex
BIN = $(OBJCOPY) -O binary -S

C_DEFS = -DCH32V307

# C includes
C_INCLUDES = -I SRC/Core/include \
				-I SRC/Peripheral/inc \
				-I SRC\FreeRTOS\include \
				-I SRC\FreeRTOS\portable\GCC\RISC-V \
				-I User\include 

AS_DEFS = $(C_DEFS)

# AS includes
AS_INCLUDES = $(C_INCLUDES)

# ldscript
LDSCRIPT = SRC\Link.ld

# 编译参数
##################
# mcu
MCU = -march=rv32imafc \
		-mabi=ilp32f 

# flags
FLAGS = $(MCU) \
		-msmall-data-limit=8 \
		-msave-restore \
		${OPT} \
		-fmessage-length=0 \
		-fsigned-char \
		-ffunction-sections \
		-fdata-sections \
		-fno-common \
		-Wunused \
		-Wuninitialized \
		-Wall 

# Cflags
CFLAGS = $(FLAGS) \
			$(C_DEFS)	\
			$(C_INCLUDES) \

# Asflags
ASFLAGS = $(FLAGS) \
			-x assembler-with-cpp \
			$(AS_DEFS) \
			$(AS_INCLUDES) \

# Ldflags
LDFLAGS = $(MCU) \
			-nostartfiles \
			-Xlinker --gc-sections \
			-T"$(LDSCRIPT)" \
			-Wl,-Map="$(BUILD_DIR)/$(TARGET).map" \
			--specs=nano.specs \
			--specs=nosys.specs \

all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin

OBJS := 

ASM_SOURCES :=

# C_SOURCES += $(wildcard SRC/Core/SRC/*.c)

# $(info $(C_SOURCES))

include SRC/build.mk


$(BUILD_DIR)/%.o: %.s Makefile 
	$(AS) -c $(CFLAGS) $< -o $@

$(BUILD_DIR):
	mkdir $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJS) | $(BUILD_DIR)
	@$(LD) $(OBJS) $(LDFLAGS) -o $@
	$(SIZE) $@

$(BUILD_DIR)/$(TARGET).bin: $(BUILD_DIR)/$(TARGET).elf
	@$(BIN) $< $@
	cp $@ out/$(TARGET).bin

$(BUILD_DIR)/$(TARGET).hex: $(BUILD_DIR)/$(TARGET).elf
	@$(HEX) $< $@
	cp $@ out/$(TARGET).hex

clean:
	@rm -fR $(BUILD_DIR)
	@rm out/$(TARGET).bin
	@rm out/$(TARGET).hex

flash:
	@cd out&&D:\\MounRiver\\MounRiver_Studio\\toolchain\\OpenOCD\\bin\\openocd.exe -f "D:\\MounRiver\\MounRiver_Studio\\toolchain\\OpenOCD\\bin\\wch-riscv.cfg" -c "init" -c "reset halt;wait_halt;flash write_image erase app.bin 0x00000000" -c "reset" -c "shutdown"
