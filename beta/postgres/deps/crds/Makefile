include ../../../../mkpm.mk
ifneq (,$(MKPM_READY))
include $(MKPM)/gnu

export CRDS := templates/crds/perconapgclusters-crd.yaml \
	templates/crds/pgclusters-crd.yaml \
	templates/crds/pgpolicies-crd.yaml \
	templates/crds/pgreplicas-crd.yaml \
	templates/crds/pgtasks-crd.yaml
export PATCHES := $(CRDS)

include $(MKPM)/patch

export CURL ?= curl
export OPERATOR_VERSION ?= 1.3.0

.PHONY: prepack
prepack: | \
	$(PATCHES) \
	patch-apply

$(CRDS):
	@$(MKDIR) -p $(@D)
	@$(CURL) -Lo $@ \
		https://raw.githubusercontent.com/percona/percona-postgresql-operator/v$(OPERATOR_VERSION)/installers/ansible/roles/pgo-operator/files/crds/$(@F)

endif
