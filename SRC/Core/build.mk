C_DIR := Core


TMP_DIR := $(BUILD_SRC_DIR)/$(C_DIR)

TMPBU_O := $(addprefix $(TMP_DIR)/,$(notdir $(patsubst %.c,%.o,$(wildcard $(SRC_DIR)/$(C_DIR)/SRC/*.c))))

$(TMP_DIR)/%.o: $(SRC_DIR)/$(C_DIR)/SRC/%.c | $(TMP_DIR)
	$(info $@)
	@$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(@:.o=.lst) $< -o $@

$(TMP_DIR): | $(BUILD_SRC_DIR)
	mkdir $@

OBJS += $(TMPBU_O)