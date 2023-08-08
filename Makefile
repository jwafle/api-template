.PHONY: build clean test default run

VERSION ?= $(shell git describe --tags 2>/dev/null)
ifeq ($(VERSION),)
VERSION := $(shell git rev-parse --short HEAD)
endif

# Use Richgo if installed for pretty test output
GOTEST ?= $(shell which richgo)
ifeq ($(GOTEST),)
GOTEST := go
endif

COMPOSE_FP = docker-compose.yml

OUTPUT = API_REPO_NAME