include ../../../../mkpm.mk
ifneq (,$(MKPM_READY))
include $(MKPM)/gnu

export PATCHES := templates/operator.yaml

include $(PROJECT_ROOT)/patch.mk

export CURL ?= curl
export OPERATOR_VERSION ?= v1.1.0

.PHONY: prepack
prepack: | $(PATCHES) patch-apply

templates/operator.yaml:
	@$(MKDIR) -p $(@D)
	@$(CURL) -Lo $@ \
		https://raw.githubusercontent.com/percona/percona-postgresql-operator/$(OPERATOR_VERSION)/deploy/operator.yaml

endif
