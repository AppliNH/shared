
# This make file uses composition to keep things KISS and easy.
# In the boilerpalte make files dont do any includes, because you will create multi permutations of possibilities.

BOILERPLATE_FSPATH=./boilerplate

include $(BOILERPLATE_FSPATH)/help.mk
include $(BOILERPLATE_FSPATH)/os.mk
include $(BOILERPLATE_FSPATH)/gitr.mk
include $(BOILERPLATE_FSPATH)/tool.mk
include $(BOILERPLATE_FSPATH)/flu.mk
include $(BOILERPLATE_FSPATH)/go.mk


# remove the "v" prefix
VERSION ?= $(shell echo $(TAGGED_VERSION) | cut -c 2-)

override FLU_SAMPLE_NAME =client
override FLU_LIB_NAME =client


## Print all settings
this-print: ## print
	
	$(MAKE) os-print
	
	$(MAKE) gitr-print

	$(MAKE) go-print

	$(MAKE) tool-print
	
	$(MAKE) flu-print

	$(MAKE) flu-gen-lang-print

	
## Dep for CI
this-dep:
	# none

## Build in CI
this-all: this-print 
	# build
	cd ./tool && $(MAKE) this-build
	
	# test
	cd ./tool && $(MAKE) this-test

### Sync

# Repos
LIB_MAIN_FSPATH=./../main
LIB_MOD_FSPATH=$(PWD)/../mod
LIB_SYS_FSPATH=$(PWD)/../sys

# Folder uses in all repos.
BOILER_NAME=boilerplate
DOC_NAME=doc

## Force catchup from Upsteam for all repos.
this-git-sync-all:

	# Shared is the MASTER of boilerplate, docs and in the Generation tools (using go_generate)
	# this is  useful command for devs to quickly ensure they have all their repos up to date.
	# we always work off git master branch.

	# MAIN
	@echo Doing $(LIB_MAIN_FSPATH)
	cd $(LIB_MAIN_FSPATH) && $(MAKE) gitr-fork-catchup

	# MOD
	@echo Doing $(LIB_MOD_FSPATH)
	cd $(LIB_MOD_FSPATH) && $(MAKE) gitr-fork-catchup

	# SYS
	@echo Doing $(LIB_SYS_FSPATH)
	cd $(LIB_SYS_FSPATH) && $(MAKE) gitr-fork-catchup


## Copy boilerplate and docs to other repos.
this-git-copy-all:

	# MAIN
	@echo Doing: $(LIB_MAIN_FSPATH)
	# boiler
	rm -rf $(LIB_MAIN_FSPATH)/$(BOILER_NAME)
	cp -Rvi ./boilerplate $(LIB_MAIN_FSPATH)/$(BOILER_NAME)
	# doc
	rm -rf $(LIB_MAIN_FSPATH)/$(DOC_NAME)
	cp -Rvi ./doc $(LIB_MAIN_FSPATH)/$(DOC_NAME)

	# MOD
	@echo Doing: $(LIB_MOD_FSPATH)
	# boiler
	rm -rf $(LIB_MOD_FSPATH)/$(BOILER_NAME)
	cp -Rvi ./boilerplate $(LIB_MOD_FSPATH)/$(BOILER_NAME)
	# doc
	rm -rf $(LIB_MOD_FSPATH)/$(DOC_NAME)
	cp -Rvi ./doc $(LIB_MOD_FSPATH)/$(DOC_NAME)

	# SYS
	@echo Doing: $(LIB_SYS_FSPATH)
	# boiler
	rm -rf $(LIB_SYS_FSPATH)/$(BOILER_NAME)
	cp -Rvi ./boilerplate $(LIB_SYS_FSPATH)/$(BOILER_NAME)
	# doc
	rm -rf $(LIB_SYS_FSPATH)/$(DOC_NAME)
	cp -Rvi ./doc $(LIB_SYS_FSPATH)/$(DOC_NAME)