SRC_DIR := SRC
BUILD_SRC_DIR := $(BUILD_DIR)/$(SRC_DIR)
$(BUILD_SRC_DIR): | $(BUILD_DIR)
	mkdir $@

include $(SRC_DIR)/FreeRTOS/build.mk
include $(SRC_DIR)/Core/build.mk
include $(SRC_DIR)/Peripheral/build.mk

SETUPASM := $(SRC_DIR)/Startup/startup_ch32v30x_D8C.S
TMPASM_O := $(addprefix $(BUILD_SRC_DIR)/,startup_ch32v30x_D8C.o)

$(TMPASM_O): $(SETUPASM) | $(BUILD_SRC_DIR)
	$(info $@)
	@$(AS) -c $(ASFLAGS) $< -o $@

OBJS += $(TMPASM_O)