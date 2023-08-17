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
OUTPUT = api_repo_name
GO_SOURCES = $(shell find . -type f -name '*.go') go.mod

# Pass the version into the main.version
LDFLAGS = -X main.version=${VERSION}

# The default will run tests and build
default: test build

build: go build -o $(OUTPUT) main.go

# build-linux will create the linux binary
build-linux: go build -o linux-${OUTPUT}-${VERSION} main.go

# test will test the entire codebase
test:
	${GOTEST} test ./...

# test-cover will test the entire codebase and generate a coverage report
test-cover:
	${GOTEST} test ./... -coverprofile=coverage.out
	go tool cover -html=coverage.out
	rm coverage.out

${OUTPUT}: ${GO_SOURCES}
	go get -v ./...
	GO111MODULE=on CGO_ENABLED=0 go build -ldflags "${LDFLAGS}" -a -installsuffix cgo -o ${OUTPUT} main.go

linux-${OUTPUT}-${VERSION}: ${GO_SOURCES}
	rm linux-${OUTPUT}-* 2>&1 | cat > /dev/null
	GO111MODULE=on CGO_ENABLED=0 GOOS=linux go build -ldflags "${LDFLAGS}" -a -installsuffix cgo -o linux-${OUTPUT}-${VERSION} main.go

clean:
	rm -f ${OUTPUT}
	rm -f linux-${OUTPUT}-*
	if [ "$$(docker-compose -f ${COMPOSE_FP} ps | wc -l)" -gt "0" ]; then docker-compose -f ${COMPOSE_FP} down ; fi

run: linux-${OUTPUT}-${VERSION}
	docker-compose -f ${COMPOSE_FP} build
	docker-compose -f ${COMPOSE_FP} up -d