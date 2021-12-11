export DIFF ?= diff
export PATCH ?= patch

export PATCHES_TMP := $(addsuffix .tmp,$(PATCHES))
export PATCHES_PATCH := $(addprefix patches/,$(addsuffix .patch,$(PATCHES)))

.PHONY: patch-apply
patch-apply: $(PATCHES) $(PATCHES_PATCH)
	@for f in $(PATCHES); do \
		$(CAT) patches/$${f}.patch | $(PATCH) -p0 -N -r$(NULL) || $(TRUE); \
	done

.PHONY: patch-revert
patch-revert: $(PATCHES) $(PATCHES_PATCH)
	@for f in $(PATCHES); do \
		$(CAT) patches/$${f}.patch | $(PATCH) -p0 -N -r$(NULL) -R || $(TRUE); \
	done

.PHONY: patch-build
patch-build: patch-revert $(PATCHES_TMP)
	@for f in $(PATCHES); do \
		$(DIFF) -Naur $$f $${f}.tmp > patches/$${f}.patch || $(TRUE); \
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
