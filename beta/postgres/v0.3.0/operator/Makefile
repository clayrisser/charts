include ../../../../mkpm.mk
ifneq (,$(MKPM_READY))
include $(MKPM)/gnu

export PATCHES := templates/operator.yaml

include $(PROJECT_ROOT)/patch.mk

export CURL ?= curl
export OPERATOR_VERSION ?= v1.1.0

CRDS ?= templates/crds/perconapgclusters-crd.yaml \
	templates/crds/pgclusters-crd.yaml \
	templates/crds/pgpolicies-crd.yaml \
	templates/crds/pgreplicas-crd.yaml \
	templates/crds/pgtasks-crd.yaml

.PHONY: prepack
prepack: | $(CRDS) $(PATCHES) patch-apply

templates/operator.yaml:
	@$(MKDIR) -p $(@D)
	@$(CURL) -Lo $@ \
		https://raw.githubusercontent.com/percona/percona-postgresql-operator/$(OPERATOR_VERSION)/deploy/operator.yaml

$(CRDS):
	@$(MKDIR) -p $(@D)
	@$(CURL) -Lo $@ \
		https://raw.githubusercontent.com/percona/percona-postgresql-operator/$(OPERATOR_VERSION)/installers/ansible/roles/pgo-operator/files/crds/$(@F)

endif
