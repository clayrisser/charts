.PHONY: generate_changelog
generate_changelog: export CHANGELOG_RELEASE ?= dev
generate_changelog:
	# Generating new changelog entries
	@gitlab-changelog -project-id 6329679 \
		-release $(CHANGELOG_RELEASE) \
		-starting-point-matcher "v[0-9]*.[0-9]*.[0-9]*" \
		-config-file .gitlab/changelog.yml \
		-changelog-file CHANGELOG.md

