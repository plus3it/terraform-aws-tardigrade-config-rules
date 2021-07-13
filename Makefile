export FIND_EXCLUDES = -not \( -name .terraform -prune \) -not \( -name .terragrunt-cache -prune \) -not \( -name vendor -prune \)

SHELL := /bin/bash

include $(shell test -f .tardigrade-ci || curl -sSL -o .tardigrade-ci "https://raw.githubusercontent.com/plus3it/tardigrade-ci/master/bootstrap/Makefile.bootstrap"; echo .tardigrade-ci)
