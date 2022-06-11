include ../../../../mkpm.mk
ifneq (,$(MKPM_READY))
include $(MKPM)/gnu

export PATCHES := templates/crds/perconapgclusters-crd.yaml \
	templates/crds/pgclusters-crd.yaml \
	templates/crds/pgpolicies-crd.yaml \
	templates/crds/pgreplicas-crd.yaml \
	templates/crds/pgtasks-crd.yaml

include $(MKPM)/patch

export CURL ?= curl
export OPERATOR_VERSION ?= v1.1.0

.PHONY: prepack
prepack: | $(PATCHES) patch-apply

$(PATCHES):
	@$(MKDIR) -p $(@D)
	@$(CURL) -Lo $@ \
		https://raw.githubusercontent.com/percona/percona-postgresql-operator/$(OPERATOR_VERSION)/installers/ansible/roles/pgo-operator/files/crds/$(@F)

endif
