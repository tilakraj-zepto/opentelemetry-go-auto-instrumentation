# Copyright (c) 2024 Alibaba Group Holding Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#-------------------------------------------------------------------------------
# General build options
MAIN_VERSION := $(shell git describe --tags --abbrev=0 | sed 's/^v//')

CURRENT_OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
CURRENT_ARCH := $(shell uname -m | sed 's/aarch64/arm64/;s/armv7l/arm/;s/armv6l/arm/')

MOD_NAME := github.com/alibaba/opentelemetry-go-auto-instrumentation
STRIP_DEBUG := -s -w
# default build cmd without ldflags
BUILD_CMD = CGO_ENABLED=0 GOOS=$(1) GOARCH=$(2) go build -a -o $(3) ./tool/cmd

OUTPUT_BASE = otel
OUTPUT_DARWIN_AMD64 = $(OUTPUT_BASE)-darwin-amd64
OUTPUT_LINUX_AMD64 = $(OUTPUT_BASE)-linux-amd64
OUTPUT_WINDOWS_AMD64 = $(OUTPUT_BASE)-windows-amd64.exe
OUTPUT_DARWIN_ARM64 = $(OUTPUT_BASE)-darwin-arm64
OUTPUT_LINUX_ARM64 = $(OUTPUT_BASE)-linux-arm64

#-------------------------------------------------------------------------------
# Prepare version
# Get the current Git commit ID
CHECK_GIT_DIRECTORY := $(if $(wildcard .git),true,false)
ifeq ($(CHECK_GIT_DIRECTORY),true)
	COMMIT_ID := $(shell git rev-parse --short HEAD)
else
	COMMIT_ID := default
endif

VERSION := $(MAIN_VERSION)_$(COMMIT_ID)
XVALUES := -X=$(MOD_NAME)/tool/config.ToolVersion=$(VERSION) -X=$(MOD_NAME)/tool/config.BuildPath=$(PWD)/pkg -X=$(MOD_NAME)/pkg/inst-api/version.Tag=v$(VERSION)
LDFLAGS := -ldflags="$(XVALUES) $(STRIP_DEBUG)"
GCFLAGS := -gcflags="all=-trimpath=$(PWD)" -asmflags="all=-trimpath=$(PWD)" 
BUILD_CMD = CGO_ENABLED=0 GOOS=$(1) GOARCH=$(2) go build -a $(LDFLAGS) $(GCFLAGS) -o $(3) ./tool/cmd

#-------------------------------------------------------------------------------
# Multiple OS and ARCH support
ifeq ($(CURRENT_ARCH), x86_64)
   CURRENT_ARCH := amd64
endif

# Check if current os contains "MINGW" or "MSYS" to determine if it is Windows
ifeq ($(findstring mingw,$(CURRENT_OS)),mingw)
   CURRENT_OS := windows
endif

ifeq ($(findstring msys,$(CURRENT_OS)),msys)
   CURRENT_OS := windows
endif

#-------------------------------------------------------------------------------
# Build targets
.PHONY: build
build: tidy
	$(eval OUTPUT_BIN=$(OUTPUT_BASE))
ifeq ($(CURRENT_OS),windows)
	$(eval OUTPUT_BIN=$(OUTPUT_BASE).exe)
endif
	$(call BUILD_CMD,$(CURRENT_OS),$(CURRENT_ARCH),$(OUTPUT_BIN))

.PHONY: all test clean

all: clean darwin_amd64 linux_amd64 windows_amd64 darwin_arm64 linux_arm64

darwin_amd64: tidy
	$(call BUILD_CMD,darwin,amd64,$(OUTPUT_DARWIN_AMD64))

linux_amd64: tidy
	$(call BUILD_CMD,linux,amd64,$(OUTPUT_LINUX_AMD64))

windows_amd64: tidy
	$(call BUILD_CMD,windows,amd64,$(OUTPUT_WINDOWS_AMD64))

darwin_arm64: tidy
	$(call BUILD_CMD,darwin,arm64,$(OUTPUT_DARWIN_ARM64))

linux_arm64: tidy
	$(call BUILD_CMD,linux,arm64,$(OUTPUT_LINUX_ARM64))

.PHONY: tidy
tidy:
	go mod tidy

clean:
	rm -f $(OUTPUT_DARWIN_AMD64) $(OUTPUT_LINUX_AMD64) $(OUTPUT_WINDOWS_AMD64) $(OUTPUT_DARWIN_ARM64) $(OUTPUT_LINUX_ARM64) $(OUTPUT_BASE)
	go clean

test:
	go test -a -timeout 50m -v $(MOD_NAME)/test

install: build
	@echo "Running install process..."
	cp $(OUTPUT_BASE) /usr/local/bin/
	@echo "Installed at /usr/local/bin/$(OUTPUT_BASE)"
