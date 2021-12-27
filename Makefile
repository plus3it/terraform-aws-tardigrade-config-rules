SHELL := /bin/bash

export TARDIGRADE_CI_ORG = lorengordon
export TARDIGRADE_CI_BRANCH = pin-localstack

include $(shell test -f .tardigrade-ci || curl -sSL -o .tardigrade-ci "https://raw.githubusercontent.com/plus3it/tardigrade-ci/master/bootstrap/Makefile.bootstrap"; echo .tardigrade-ci)
