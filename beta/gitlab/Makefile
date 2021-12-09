include ../../mkpm.mk
ifneq (,$(MKPM_READY))
include $(MKPM)/gnu

export CURL ?= curl
export DIFF ?= diff
export PATCH ?= patch
export OPERATOR_VERSION ?= 0.2.0

.PHONY: prepack
prepack: ;

.PHONY: patch
patch: templates/operator.yaml.patch templates/operator.yaml
	@$(CAT) $< | $(PATCH) -p0

.PHONY: diff
diff: templates/operator.yaml templates/operator.new.yaml
	@$(DIFF) -u $^ > templates/operator.yaml.patch || $(TRUE)

templates/operator.yaml:
	@$(CURL) -Lo $@ \
		https://gitlab.com/api/v4/projects/18899486/packages/generic/gitlab-operator/$(OPERATOR_VERSION)/gitlab-operator-kubernetes-$(OPERATOR_VERSION).yaml

templates/operator.new.yaml: templates/operator.yaml
	@$(CP) $< $@

endif
