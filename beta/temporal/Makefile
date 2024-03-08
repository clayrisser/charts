include $(MKPM)/mkpm
include $(MKPM)/gnu

export PATCHES :=

include $(MKPM)/patch

.PHONY: prepack
prepack: patch-apply

NAMESPACE ?= temporal
.PHONY: install
install:
	@helm upgrade --install temporal ./ -n $(NAMESPACE) --debug \
		$$([ -f test.values.yaml ] && $(ECHO) "-f test.values.yaml" || $(TRUE)) $(ARGS)
