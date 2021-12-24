include ../../../mkpm.mk
ifneq (,$(MKPM_READY))
include $(MKPM)/gnu

export PATCHES := templates/operator.yaml

include $(PROJECT_ROOT)/patch.mk

export CURL ?= curl
export OPERATOR_VERSION ?= 0.2.0

.PHONY: prepack
prepack: templates/operator.yaml patch-apply

templates/operator.yaml:
	@$(CURL) -Lo $@ \
		https://gitlab.com/api/v4/projects/18899486/packages/generic/gitlab-operator/$(OPERATOR_VERSION)/gitlab-operator-kubernetes-$(OPERATOR_VERSION).yaml

endif
