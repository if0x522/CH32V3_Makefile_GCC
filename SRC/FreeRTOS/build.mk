C_DIR := FreeRTOS

# FreeRTOS 核心
TMP_DIR := $(BUILD_SRC_DIR)/$(C_DIR)

TMPBU_O := $(addprefix $(TMP_DIR)/,$(notdir $(patsubst %.c,%.o,$(wildcard $(SRC_DIR)/$(C_DIR)/*.c))))

$(TMP_DIR)/%.o: $(SRC_DIR)/$(C_DIR)/%.c | $(TMP_DIR)
	$(info $@)
	@$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(@:.o=.lst) $< -o $@

$(TMP_DIR): | $(BUILD_SRC_DIR)
	mkdir $@

OBJS += $(TMPBU_O)

# 汇编
FreeRTOSAS := $(SRC_DIR)/$(C_DIR)/portASM.S
TMPAS_O := $(addprefix $(TMP_DIR)/,portASM.o)

$(TMPAS_O): $(FreeRTOSAS) | $(TMP_DIR)
	$(info $@)
	@$(AS) -c $(ASFLAGS) $< -o $@

OBJS += $(TMPAS_O)
