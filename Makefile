HUGO_VERSION ?= 0.76.5
HUGO_PORT ?= 1313

.PHONY: all
all: build

.PHONY: build
build:
	hugo

.PHONY: bump-version-hugo
bump-version-hugo:
	@grep -lR "$(HUGO_VERSION)" . | \
		grep -v "^\./\.git/" | \
		grep -v "\.swp\$$"

.PHONY: clean
clean:
	rm -rf resources

.PHONY: deploy
deploy:
	./deploy.sh

.PHONY: run
run:
	hugo server -DEF --noHTTPCache --i18n-warnings --disableFastRender \
		--bind 0.0.0.0 --port $(HUGO_PORT) --baseUrl / --appendPort=false

# Docker

DOCKER_IMAGE_TAG := $(HUGO_VERSION)

.PHONY: docker-build
docker-build:
	@docker run --rm -it \
		-u $$(id -u $$USER) \
		-v "$${TMPDIR:-/tmp}":/tmp/ \
		-v "$$PWD":/site/ \
		ntrrg/hugo:$(DOCKER_IMAGE_TAG)

.PHONY: docker-run
docker-run:
	@docker run --rm -it \
		-e PORT=$(HUGO_PORT) \
		-p $(HUGO_PORT):$(HUGO_PORT) \
		-u $$(id -u $$USER) \
		-v "$${TMPDIR:-/tmp}":/tmp/ \
		-v "$$PWD":/site/ \
		ntrrg/hugo:$(DOCKER_IMAGE_TAG) server -DEF --noHTTPCache --i18n-warnings \
			--disableFastRender \
			--bind 0.0.0.0 --port $(HUGO_PORT) --baseUrl / --appendPort=false

.PHONY: docker-shell
docker-shell:
	@docker run --rm -it \
		-u $$(id -u $$USER) \
		-v "$${TMPDIR:-/tmp}":/tmp/ \
		-v "$$PWD":/site/ \
		--entrypoint sh \
		ntrrg/hugo:$(DOCKER_IMAGE_TAG)

