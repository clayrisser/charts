include ../../mkpm.mk
ifneq (,$(MKPM_READY))
include $(MKPM)/gnu

export PATCHES := templates/operator.yaml

include $(MKPM)/patch

export CURL ?= curl
export OPERATOR_VERSION ?= v1.10.0

.PHONY: prepack
prepack: | templates/operator.yaml patch-apply

templates/operator.yaml:
	@$(MKDIR) -p $(@D)
	@$(CURL) -Lo $@ \
		https://raw.githubusercontent.com/percona/percona-xtradb-cluster-operator/${OPERATOR_VERSION}/deploy/bundle.yaml

endif
