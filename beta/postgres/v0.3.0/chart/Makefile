include ../../../../mkpm.mk
ifneq (,$(MKPM_READY))
include $(MKPM)/gnu

export PATCHES :=

include $(PROJECT_ROOT)/patch.mk

export CURL ?= curl

.PHONY: prepack
prepack: | $(PATCHES) patch-apply

endif
