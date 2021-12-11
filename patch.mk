export PATCHES ?=
export PATCHES_DIR ?= patches

export DIFF ?= diff
export PATCH ?= patch

export PATCHES_TMP := $(addsuffix .tmp,$(PATCHES))
export PATCHES_PATCH := $(addprefix patches/,$(addsuffix .patch,$(PATCHES)))

.PHONY: patch-apply
patch-apply: $(PATCHES) $(PATCHES_PATCH)
	@for f in $(PATCHES); do \
		[ -f "$(PATCHES_DIR)/$${f}.patch" ] && \
		$(CAT) "$(PATCHES_DIR)/$${f}.patch" | $(PATCH) -p0 -N -r$(NULL) || $(TRUE); \
	done

.PHONY: patch-revert
patch-revert: $(PATCHES) $(PATCHES_PATCH)
	@for f in $(PATCHES); do \
		[ -f "$(PATCHES_DIR)/$${f}.patch" ] && \
		$(CAT) "$(PATCHES_DIR)/$${f}.patch" | $(PATCH) -p0 -N -r$(NULL) -R || $(TRUE); \
	done

.PHONY: patch-build
patch-build: patch-revert $(PATCHES_TMP)
	@for f in $(PATCHES); do \
		$(MKDIR) -p "$$($(ECHO) "$(PATCHES_DIR)/$${f}.patch" | $(SED) 's|[\\\\/][^\\\/]*$$||g')" && \
		$(DIFF) -Naur "$$f" "$${f}.tmp" > "$(PATCHES_DIR)/$${f}.patch" || $(TRUE); \
	done
$(PATCHES_TMP):
	@$(CP) $(patsubst %.tmp,%,$@) $@
.SECONDEXPANSION:
$(PATCHES_PATCH): ;

.PHONY: patch-build-clear
patch-build-clear: $(PATCHES_TMP) $(PATCHES_PATCH)
	@$(RM) -rf $^ || $(TRUE)

.PHONY: patch-build-reset
patch-build-reset: patch-build-clear
	@$(MAKE) -s patch-build
