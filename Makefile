CHART := .
CHARTS := $(shell git ls-files | grep -oE '.+\/Chart\.yaml' | sed 's/\/Chart\.yaml$$//g' | sort -u)

.PHONY: all
all: $(CHARTS)

.PHONY: lint ~lint +lint
lint:
ifeq ($(CHART),.)
	@for c in $(CHARTS); do \
			echo LINTING: $$c && \
			$(MAKE) -s lint CHART="$$c"; \
		done
else
	@helm lint alertmanager-bot $(CHART)
endif

.PHONY: debug
debug:
ifeq ($(CHART),.)
	@for c in $(CHARTS); do \
			echo DEBUGGING: $$c && \
			$(MAKE) -s debug CHART="$$c"; \
		done
else
	@helm install --debug --dry-run --generate-name $(CHART)
endif

.PHONY: publish
publish:
ifeq ($(CHART),.)
	@for c in $(CHARTS); do \
			echo PUBLISHING: $$c && \
			$(MAKE) -s publish CHART="$$c"; \
		done
else
	VERSION=$$(cat $(CHART)/Chart.yaml | grep -E "^version: " | sed 's|version: ||g') && \
	CHART_NAME=$$(echo $(CHART) | sed 's|^[^\/]*\/||g' | sed 's|\/[^\/]*$$||g') && \
		helm chart save $(CHART) $$CI_REGISTRY/$$CI_PROJECT_NAMESPACE/$$CHART_NAME:$$VERSION-$$CI_COMMIT_TAG && \
		helm chart push $$CI_REGISTRY/$$CI_PROJECT_NAMESPACE/$$CHART_NAME:$$VERSION-$$CI_COMMIT_TAG
endif

.PHONY: $(CHARTS)
$(CHARTS):
	@$(MAKE) -s debug CHART="$@"
