include $(MKPM)/mkpm
include $(MKPM)/gnu

export PATCHES :=

include $(MKPM)/patch

export CURL ?= curl
export APPLICATION_CRD_VERSION ?= v0.8.3

.PHONY: prepack
prepack: templates/application-crd.yaml patch-apply

templates/application-crd.yaml:
	@$(MKDIR) -p $(@D)
	@$(CURL) -Lo $@ \
		https://raw.githubusercontent.com/kubernetes-sigs/application/$(APPLICATION_CRD_VERSION)/config/crd/bases/app.k8s.io_applications.yaml
