include ../../mkpm.mk
ifneq (,$(MKPM_READY))
include $(MKPM)/gnu

export PATCHES := templates/olm.yaml

include $(MKPM)/patch

export CURL ?= curl
export OPERATOR_VERSION ?= 0.21.2

.PHONY: prepack
prepack: | \
	templates/olm.yaml \
	patch-apply

templates/olm.yaml:
	@$(MKDIR) -p $(@D)
	@$(CURL) -Lo $@ \
		https://raw.githubusercontent.com/operator-framework/operator-lifecycle-manager/v$(OPERATOR_VERSION)/deploy/upstream/quickstart/olm.yaml

endif
