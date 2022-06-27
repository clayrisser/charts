include ../../mkpm.mk
ifneq (,$(MKPM_READY))
include $(MKPM)/gnu

export PATCHES :=

include $(MKPM)/patch

export CURL ?= curl
export OPERATOR_VERSION ?= 0.21.2

.PHONY: prepack
prepack: | \
	templates/olm.yaml \
	charts/crds/crds.yaml \
	patch-apply

charts/crds/crds.yaml:
	@$(MKDIR) -p $(@D)
	@$(CURL) -Lo $@ \
		https://raw.githubusercontent.com/operator-framework/operator-lifecycle-manager/v$(OPERATOR_VERSION)/deploy/upstream/quickstart/crds.yaml

templates/olm.yaml:
	@$(MKDIR) -p $(@D)
	@$(CURL) -Lo $@ \
		https://raw.githubusercontent.com/operator-framework/operator-lifecycle-manager/v$(OPERATOR_VERSION)/deploy/upstream/quickstart/olm.yaml

endif
