include $(MKPM)/mkpm
include $(MKPM)/gnu

export PATCHES := templates/operator.yaml

include $(MKPM)/patch

export CURL ?= curl
export OPERATOR_VERSION ?= 0.5.1

.PHONY: prepack
prepack: templates/operator.yaml patch-apply

templates/operator.yaml:
	@$(MKDIR) -p $(@D)
	@$(CURL) -Lo $@ \
		https://gitlab.com/api/v4/projects/18899486/packages/generic/gitlab-operator/$(OPERATOR_VERSION)/gitlab-operator-kubernetes-$(OPERATOR_VERSION).yaml
