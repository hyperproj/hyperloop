SHELL = /bin/bash
.SHELLFLAGS = -o pipefail -c

# SRC_ROOT is the top of the source tree.
SRC_ROOT := $(shell git rev-parse --show-toplevel)
# SRC_PARENT_DIR is the absolute path of source tree's parent directory
SRC_PARENT_DIR := $(shell dirname $(SRC_ROOT))

LOCAL_TOOLS := $(SRC_ROOT)/tools
THIRD_PARTY := $(SRC_ROOT)/third_party

DOCKERCMD ?= docker
KINDCMD ?= kind

OS := $(shell uname | tr A-Z a-z)
ARCH := $(shell uname -m)

GOCMD ?= go
GOOS=$(shell $(GOCMD) env GOOS)
GOARCH=$(shell $(GOCMD) env GOARCH)
GOBIN ?= $(GOPATH)/bin
# build tags required by any component should be defined as an independent variables and later added to GO_BUILD_TAGS below
GO_BUILD_TAGS=""
# These ldflags allow the build tool to omit the symbol table, debug information, and the DWARF symbol table to downscale binary size.
GO_BUILD_LDFLAGS := "-s -w"
GO_BUILD_FLAGS := -trimpath
GO_CGO_ENABLED ?= 0

# This is the code that we want to run lint, etc.
ALL_SRC := $(shell find $(SRC_ROOT) -name '*.go' -o -name '*.proto' \
							-not -path '*/third_party/*' \
							-type f | sort)

# All source code and documents. Used in spell check.
ALL_DOC := $(shell find . \( -name "*.md" -o -name "*.yaml" \) \
                                -type f | sort)


BINAPI_GENERATOR_VERSION ?= latest
.PHONY: install-binapi-generator
install-binapi-generator:
ifeq (, $(shell which binapi-generator))
	@echo "⬇️ Installing binapi-generator@$(BINAPI_GENERATOR_VERSION)..."
	go install go.fd.io/govpp/cmd/binapi-generator@$(BINAPI_GENERATOR_VERSION)
	@echo "✅ binapi-generator@$(BINAPI_GENERATOR_VERSION) install successful"
BINAPI_GENERATOR_BIN=$(GOBIN)/binapi-generator
else
	@echo "✅ binapi-generator@$(BINAPI_GENERATOR_VERSION) already exists at $(GOBIN)/binapi-generator"
BINAPI_GENERATOR_BIN=$(shell which binapi-generator)
endif

# proto compiler installation
PROTOC_VERSION ?= 30.2
ifeq ($(ARCH),x86_64)
	PROTOC_ARCH := x86_64
endif
ifeq ($(ARCH),aarch64)
	PROTOC_ARCH := aarch_64
endif
PROTOC_ZIP = protoc-$(PROTOC_VERSION)-$(OS)-$(PROTOC_ARCH).zip
PROTOC_URL = https://github.com/protocolbuffers/protobuf/releases/download/v$(PROTOC_VERSION)/$(PROTOC_ZIP)
PROTOC_DIR = $(LOCAL_TOOLS)/protobuf
PROTOC_BIN = $(PROTOC_DIR)/bin/protoc
.PHONY: install-protoc
install-protoc: install-protoc-gen-go install-protoc-gen-go-grpc
	@if [ -f $(PROTOC_BIN) ]; then \
		echo "✅ protoc@$(PROTOC_VERSION) already exists at $(PROTOC_BIN)"; \
	else \
		echo "⬇️ Downloading protoc@$(PROTOC_VERSION) for $(OS)/$(ARCH)..."; \
		mkdir -p $(PROTOC_DIR); \
		curl -sSL $(PROTOC_URL) -o /tmp/$(PROTOC_ZIP); \
		unzip -o /tmp/$(PROTOC_ZIP) -d $(PROTOC_DIR); \
		chmod +x $(PROTOC_BIN); \
		rm -f /tmp/$(PROTOC_ZIP); \
		echo "✅ protoc@$(PROTOC_VERSION) installed at $(PROTOC_BIN)"; \
	fi

PROTOC_GEN_GO_VERSION ?= latest
.PHONY: install-protoc-gen-go
install-protoc-gen-go:
ifeq (, $(shell which protoc-gen-go))
	@echo "⬇️ Installing protoc-gen-go@$(PROTOC_GEN_GO_VERSION)..."
	go install google.golang.org/protobuf/cmd/protoc-gen-go@$(PROTOC_GEN_GO_VERSION)
	@echo "✅ protoc-gen-go@$(PROTOC_GEN_GO_VERSION) install successful"
else
	@echo "✅ protoc-gen-go@$(PROTOC_GEN_GO_VERSION) already exists at $(GOBIN)/protoc-gen-go"
endif

PROTOC_GEN_GO_GRPC_VERSION ?= latest
.PHONY: install-protoc-gen-go-grpc
install-protoc-gen-go-grpc:
ifeq (, $(shell which protoc-gen-go-grpc))
	@echo "⬇️ Installing protoc-gen-go-grpc@$(PROTOC_GEN_GO_GRPC_VERSION)..."
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@$(PROTOC_GEN_GO_GRPC_VERSION)
	@echo "✅ protoc-gen-go-grpc@$(PROTOC_GEN_GO_GRPC_VERSION) install successful"
else
	@echo "✅ protoc-gen-go-grpc@$(PROTOC_GEN_GO_GRPC_VERSION) already exists at $(GOBIN)/protoc-gen-go-grpc"
endif

CONTROLLER_GEN_VERSION ?= 0.17.3
.PHONY: install-controller-gen
install-controller-gen:
ifeq (, $(shell which controller-gen))
	@echo "⬇️ Installing controller-gen@v$(CONTROLLER_GEN_VERSION)..."
	go install sigs.k8s.io/controller-tools/cmd/controller-gen@v$(CONTROLLER_GEN_VERSION)
	@echo "✅ controller-gen@v$(CONTROLLER_GEN_VERSION) install successful"
else
	@echo "✅ controller-gen@v$(CONTROLLER_GEN_VERSION) already exists at $(GOBIN)/controller-gen"
endif

KUSTOMIZE_VERSION ?= 5.6.0
ifeq ($(ARCH),x86_64)
	KUSTOMIZE_ARCH := amd64
endif
ifeq ($(ARCH),aarch64)
	KUSTOMIZE_ARCH := arm64
endif
KUSTOMIZE_URL = https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v$(KUSTOMIZE_VERSION)/kustomize_v$(KUSTOMIZE_VERSION)_$(OS)_$(KUSTOMIZE_ARCH).tar.gz
KUSTOMIZE_BIN=$(LOCAL_TOOLS)/kustomize
.PHONY: install-kustomize
install-kustomize:
	@if [ -f $(KUSTOMIZE_BIN) ]; then \
		echo "✅ kustomize already exists at $(KUSTOMIZE_BIN), skipping download."; \
	else \
		echo "⬇️  Downloading kustomize $(KUSTOMIZE_VERSION) for $(OS)/$(KUSTOMIZE_ARCH)..."; \
		mkdir -p $(LOCAL_TOOLS); \
		curl -sL $(KUSTOMIZE_URL) | tar -xz -C $(LOCAL_TOOLS); \
		chmod +x $(KUSTOMIZE_BIN); \
		echo "✅ kustomize installed at $(KUSTOMIZE_BIN)"; \
	fi


ADDLICENSE   := go tool addlicense
MISSPELL     := go tool misspell

.PHONY: addlicense
addlicense: 
	@ADDLICENSEOUT=`$(ADDLICENSE) -s=only -y "" -c "The Hyperloop Authors" $(ALL_SRC) 2>&1`; \
		if [ "$$ADDLICENSEOUT" ]; then \
			echo "$(ADDLICENSE) FAILED => add License errors:\n"; \
			echo "$$ADDLICENSEOUT\n"; \
			exit 1; \
		else \
			echo "Add License finished successfully"; \
		fi

.PHONY: checklicense
checklicense: 
	@licSrc=$$(for f in $$(find . -type f \( -iname '*.go' -o -iname '*.sh' \) ! -path '**/third_party/*') ; do \
	            awk '/Copyright The Hyperloop Authors|generated|GENERATED/ && NR<=3 { found=1; next } END { if (!found) print FILENAME }' $$f; \
			    awk '/SPDX-License-Identifier: Apache-2.0|generated|GENERATED/ && NR<=4 { found=1; next } END { if (!found) print FILENAME }' $$f; \
	    done); \
	    if [ -n "$${licSrc}" ]; then \
	            echo "license header checking failed:"; echo "$${licSrc}"; \
	            exit 1; \
	    else \
			echo "Check License finished successfully"; \
	    fi

.PHONY: misspell
misspell: 
	$(MISSPELL) -error $(ALL_DOC)

.PHONY: misspell-correction
misspell-correction: 
	$(MISSPELL) -w $(ALL_DOC)


# Run go fmt against code
.PHONY: gofmt
gofmt:
	go fmt ./pkg/... ./cmd/... 

# Run go vet against code
.PHONY: govet
govet:
	CGO_ENABLED=0 go vet ./pkg/... ./cmd/...

# Run go mod tidy
.PHONY: gotidy
gotidy:
	go mod tidy


.PHONY: install-tools
install-tools: install-controller-gen install-kustomize install-protoc install-binapi-generator

.PHONY: all
all: checklicense misspell


.DEFAULT_GOAL := all