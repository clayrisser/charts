include ../../../mkpm.mk
ifneq (,$(MKPM_READY))
include $(MKPM)/gnu

export PATCHES := templates/crds/actionset.yaml \
	templates/crds/blueprint.yaml \
	templates/crds/profile.yaml

include $(PROJECT_ROOT)/patch.mk

export CURL ?= curl
export KANISTER_VERSION ?= 0.71.0

.PHONY: prepack
prepack: | templates/crds/actionset.yaml \
	templates/crds/blueprint.yaml \
	templates/crds/profile.yaml patch-apply

templates/crds/actionset.yaml:
	@$(MKDIR) -p $(@D)
	@$(CURL) -Lo $@ \
		https://raw.githubusercontent.com/kanisterio/kanister/$(KANISTER_VERSION)/pkg/customresource/actionset-crd.go

templates/crds/blueprint.yaml:
	@$(MKDIR) -p $(@D)
	@$(CURL) -Lo $@ \
		https://raw.githubusercontent.com/kanisterio/kanister/$(KANISTER_VERSION)/pkg/customresource/blueprint-crd.go

templates/crds/profile.yaml:
	@$(MKDIR) -p $(@D)
	@$(CURL) -Lo $@ \
		https://raw.githubusercontent.com/kanisterio/kanister/$(KANISTER_VERSION)/pkg/customresource/profile-crd.go

endif
