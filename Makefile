HELM := helm
GIT := git
SED := sed
GREP := grep
DOCKER := docker

CHART := .
CHARTS := $(shell $(GIT) ls-files | $(GREP) -oE '.+\/Chart\.yaml' | $(SED) 's/\/Chart\.yaml$$//g' | sort -u)

.PHONY: all
all: $(CHARTS)

.PHONY: lint
lint:
ifeq ($(CHART),.)
	-@for c in $(CHARTS); do \
			echo && \
			echo "LINTING: $$c" && \
			$(MAKE) -s lint CHART="$$c"; \
		done
else
	@$(HELM) lint $(CHART)
endif

.PHONY: debug
debug:
ifeq ($(CHART),.)
	@for c in $(CHARTS); do \
			echo && \
			echo "DEBUGGING: $$c" && \
			$(MAKE) -s debug CHART="$$c"; \
		done
else
	@$(HELM) install --debug --dry-run --generate-name $(CHART)
endif

.PHONY: package
package:
	@mkdir -p ./public
	@echo "User-Agent: *\nDisallow: /" > ./public/robots.txt
	@$(HELM) package $(CHARTS) --destination .
	@$(HELM) repo index --url https://${CI_PROJECT_NAMESPACE}.${CI_PAGES_DOMAIN}/${CI_PROJECT_NAME} .
	@mv *.tgz ./public
	@mv index.yaml ./public

.PHONY: docker-build
docker-build:
	@$(DOCKER) build -f ./Dockerfile -t codejamninja/make-helm:latest .

.PHONY: docker-push
docker-push:
	@$(DOCKER) push codejamninja/make-helm:latest

.PHONY: $(CHARTS)
$(CHARTS):
	-@$(MAKE) -s lint CHART="$@"
	-@$(MAKE) -s debug CHART="$@"
