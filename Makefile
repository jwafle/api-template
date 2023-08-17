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

# What the final binary should look like
OUTPUT = API_REPO_NAME
GO_SOURCES = $(shell find . -type f -name '*.go') go.mod

# Pass the version into the main.version
LDFLAGS = -X main.version=${VERSION}

# The default will run tests and build
default: test build

build: $(OUTPUT)

# build-linux will create the linux binary
build-linux: linux-${OUTPUT}-${VERSION}

# test will test the entire codebase
test:
	${GOTEST} test ./...

# test-cover will test the entire codebase and generate a coverage report
test-cover:
	${GOTEST} test ./... -coverprofile=coverage.out
	go tool cover -html=coverage.out
	rm coverage.out
