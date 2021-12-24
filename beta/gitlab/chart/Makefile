include ../../../mkpm.mk
ifneq (,$(MKPM_READY))
include $(MKPM)/gnu

export PATCHES :=

include $(PROJECT_ROOT)/patch.mk

.PHONY: prepack
prepack: patch-apply

endif
