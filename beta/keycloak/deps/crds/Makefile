include ../../../../mkpm.mk
ifneq (,$(MKPM_READY))
include $(MKPM)/gnu

export CRDS := templates/crds/keycloakrealmimports.k8s.keycloak.org-v1.yml \
	templates/crds/keycloaks.k8s.keycloak.org-v1.yml

export PATCHES := $(CRDS)

include $(MKPM)/patch

export CURL ?= curl
export OPERATOR_VERSION ?= 21.1.1

.PHONY: prepack
prepack: | \
	$(PATCHES) \
	patch-apply

$(CRDS):
	@$(MKDIR) -p $(@D)
	@$(CURL) -Lo $@ \
		https://raw.githubusercontent.com/k8s-operatorhub/community-operators/main/operators/keycloak-operator/$(OPERATOR_VERSION)/manifests/$(@F)

endif
