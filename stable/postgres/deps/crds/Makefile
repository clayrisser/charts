include $(MKPM)/mkpm
include $(MKPM)/gnu

export PATCHES :=

include $(MKPM)/patch

.PHONY: prepack
prepack: | \
	$(PATCHES) \
	patch-apply
