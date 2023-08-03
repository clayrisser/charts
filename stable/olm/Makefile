include $(MKPM)/mkpm
include $(MKPM)/gnu

export PATCHES := templates/olm.yaml

include $(MKPM)/patch

export CURL ?= curl
export OPERATOR_VERSION ?= 0.25.0

.PHONY: prepack
prepack: | \
	$(PATCHES) \
	patch-apply

templates/%:
	@$(MKDIR) -p $(@D)
	@$(CURL) -Lo $@ \
		https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v$(OPERATOR_VERSION)/$(@F)
