include ../../mkpm.mk
ifneq (,$(MKPM_READY))
include $(MKPM)/gnu

export PATCHES :=

include $(MKPM)/patch

.PHONY: prepack
prepack: | $(PATCHES) patch-apply

endif
