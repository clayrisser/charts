include ../../../../mkpm.mk
ifneq (,$(MKPM_READY))
include $(MKPM)/gnu

export CRDS := templates/crds/perconapgclusters.pg.percona.com.crd.yaml \
	templates/crds/pgclusters.pg.percona.com.crd.yaml \
	templates/crds/pgpolicies.pg.percona.com.crd.yaml \
	templates/crds/pgreplicas.pg.percona.com.crd.yaml \
	templates/crds/pgtasks.pg.percona.com.crd.yaml
export PATCHES := $(CRDS)

include $(MKPM)/patch

export CURL ?= curl
export OPERATOR_VERSION ?= 1.4.0

.PHONY: prepack
prepack: | \
	$(PATCHES) \
	patch-apply

$(CRDS):
	@$(MKDIR) -p $(@D)
	@$(CURL) -Lo $@ \
		https://raw.githubusercontent.com/k8s-operatorhub/community-operators/main/operators/percona-postgresql-operator/$(OPERATOR_VERSION)/manifests/$(@F)

endif
