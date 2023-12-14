include $(MKPM)/mkpm
include $(MKPM)/gnu

export PATCHES := templates/operator.yaml

include $(MKPM)/patch

export CURL ?= curl
export OPERATOR_VERSION ?= 1.3.0

.PHONY: prepack
prepack: | $(PATCHES) patch-apply

templates/operator.yaml:
	@$(MKDIR) -p $(@D)
	@$(CURL) -Lo $@ \
		https://raw.githubusercontent.com/percona/percona-postgresql-operator/v$(OPERATOR_VERSION)/deploy/operator.yaml
