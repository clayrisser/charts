include ../../../../mkpm.mk
ifneq (,$(MKPM_READY))
include $(MKPM)/gnu

export CRDS := templates/crds/keycloakbackups.keycloak.org.crd.yaml \
	templates/crds/keycloakclients.keycloak.org.crd.yaml \
	templates/crds/keycloakrealms.keycloak.org.crd.yaml \
	templates/crds/keycloaks.keycloak.org.crd.yaml \
	templates/crds/keycloakusers.keycloak.org.crd.yaml

export PATCHES := $(CRDS)

include $(MKPM)/patch

export CURL ?= curl
export OPERATOR_VERSION ?= 19.0.2

.PHONY: prepack
prepack: | \
	$(PATCHES) \
	patch-apply

$(CRDS):
	@$(MKDIR) -p $(@D)
	@$(CURL) -Lo $@ \
		https://raw.githubusercontent.com/k8s-operatorhub/community-operators/main/operators/keycloak-operator/$(OPERATOR_VERSION)/manifests/$(@F)

endif
