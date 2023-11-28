include $(MKPM)/mkpm
include $(MKPM)/gnu

export PATCHES :=

include $(MKPM)/patch

export CURL ?= curl
export CERT_MANAGER_VERSION ?= v1.6.1

.PHONY: prepack
prepack: templates/crds.yaml patch-apply

templates/crds.yaml:
	@$(MKDIR) -p $(@D)
	@$(CURL) -Lo $@ \
		https://github.com/jetstack/cert-manager/releases/download/$(CERT_MANAGER_VERSION)/cert-manager.crds.yaml
