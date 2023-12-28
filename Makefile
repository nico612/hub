



COMMON_SELF_DIR:=$(dir $(lastword $(MAKEFILE_LIST)))

ifeq ($(origin ROOT_DIR),undefined)
ROOT_DIR := $(abspath $(shell cd $(COMMON_SELF_DIR)/ && pwd -P))
endif

ifeq ($(origin TOOLS), undefined)
TOOLS := $(ROOT_DIR)/tools
$(shell mkdir -p $(TOOLS))
endif

.PHONY: dir
dir:
	@echo $(COMMON_SELF_DIR)
	@echo $(ROOT_DIR)


# 安装changeLog
.PHONY: installChangeLog
installChangeLog:
	@go install github.com/git-chglog/git-chglog/cmd/git-chglog@latest


.PHONY: changelog
changelog:
	@git-chglog -o CHANGELOG/CHANGELOG.md


.PHONY: installJsonExport
installJsonExport:
	@cd $(TOOLS) && \
	 git clone https://github.com/Ahmed-Ali/JSONExport
	@xcodebuild -project $(TOOLS)/JSONExport/JSONExport.xcodeproj -scheme JSONExport -destination 'platform=macOS' -configuration Release -derivedDataPath $(TOOLS)/JSONExport/build

.PHONY: runJsonExport
runJsonExport:
	@open $(TOOLS)/JSONExport/build/Build/Products/Release/JSONExport.app       
