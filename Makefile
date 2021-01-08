CHART := .
CHARTS := $(shell git ls-files | grep -oE '.+\/Chart\.yaml' | sed 's/\/Chart\.yaml$$//g' | sort -u)

.PHONY: all
all: $(CHARTS)

.PHONY: lint ~lint +lint
lint: ~lint
~lint: +lint
+lint:
	@helm lint $(CHART)

.PHONY: debug ~debug +debug
debug: ~debug
~debug: ~lint +debug
+debug:
	@helm install --debug --dry-run --generate-name $(CHART)

.PHONY: $(CHARTS)
$(CHARTS):
	@$(MAKE) -s debug CHART="$@"
