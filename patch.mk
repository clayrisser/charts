export DIFF ?= diff
export PATCH ?= patch

export PATCHES_TMP := $(addsuffix .tmp,$(PATCHES))
export PATCHES_PATCH := $(addsuffix .patch,$(PATCHES))

.PHONY: patch-apply
patch-apply: $(PATCHES) $(PATCHES_PATCH)
	@for f in $(PATCHES); do \
		$(CAT) $${f}.patch | $(PATCH) -p0; \
	done

.PHONY: patch-build
patch-build: $(PATCHES) $(PATCHES_TMP)
	@for f in $(PATCHES); do \
		$(DIFF) -Naur $$f $${f}.tmp > $${f}.patch || $(TRUE); \
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
