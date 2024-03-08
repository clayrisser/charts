include $(MKPM)/mkpm
include $(MKPM)/gnu

export PATCHES :=

include $(MKPM)/patch

.PHONY: prepack
prepack: | \
	$(PATCHES) \
	patch-apply

.PHONY: install
install:
	@helm upgrade --install crds ./ -n kube-system --debug $(ARGS)
