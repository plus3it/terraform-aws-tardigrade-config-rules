## terraform-aws-tardigrade-config-rules Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

### 2.0.0

**Released**: 2020.09.15

**Commit Delta**: [Change from 1.0.4 release](https://github.com/plus3it/terraform-aws-tardigrade-config-rules/compare/1.0.4..2.0.0)

**Summary**:

*   Entirely reworks module to be unopionated and allow users to create arbitrary config rules.
    See `tests/create_legacy_config_rules` for a configuration that uses the new module to create
    the prior set of config rules.
*   Removes the var `create_config_rules`. Instead, use tf 0.13 and `count`/`for_each` on the module
    block. See `tests/no_create`.
*   Removes vendored custom config_rules, and instead uses a module block to pull them down during
    `terraform init`. As a result, the `source_path` for custom config_rules has changed. For an example,
    see the `source_path` argument in `tests/create_custom_config_rule`.
*   Outputs the Config Rule object as `config_rule`.

### 1.0.4

**Released**: 2019.10.28

**Commit Delta**: [Change from 1.0.3 release](https://github.com/plus3it/terraform-aws-tardigrade-config-rules/compare/1.0.3..1.0.4)

**Summary**:

*   Updates documentation generation make targets
*   Adds documentation to the test modules
*   Minor changelog fixup

### 1.0.3

**Released**: 2019.10.28

**Commit Delta**: [Change from 1.0.2 release](https://github.com/plus3it/terraform-aws-tardigrade-config-rules/compare/1.0.2...1.0.3)

**Summary**:

*   Establishes dependency link between newer config rules and the config recorder

### 1.0.2

**Released**: 2019.10.17

**Commit Delta**: [Change from 1.0.1 release](https://github.com/plus3it/terraform-aws-tardigrade-config-rules/compare/1.0.1...1.0.2)

**Summary**:

*   Adds ability to auto approve and merge Dependabot PRs

### 1.0.1

**Released**: 2019.10.03

**Commit Delta**: [Change from 1.0.0 release](https://github.com/plus3it/terraform-aws-tardigrade-config-rules/compare/1.0.0...1.0.1)

**Summary**:

*   Update testing harness to have a more user-friendly output
*   Update terratest dependencies

### 1.0.0

**Released**: 2019.09.23

**Commit Delta**: [Change from 0.0.3 release](https://github.com/plus3it/terraform-aws-tardigrade-config-rules/compare/0.0.3...1.0.0)

**Summary**:

*   Upgrade to terraform 0.12.x
*   Add test cases

### 0.0.3

**Commit Delta**: [Change from 0.0.2 release](https://github.com/plus3it/terraform-aws-tardigrade-config-rules/compare/0.0.2...0.0.3)

**Released**: 2019.09.19

**Summary**:

*   New config rules for unrestricted security group ports and public ebs snapshots

### 0.0.2

**Commit Delta**: [Change from 0.0.1 release](https://github.com/plus3it/terraform-aws-tardigrade-config-rules/compare/0.0.1...0.0.2)

**Released**: 2019.09.04

**Summary**:

*   Patched location of vendored community rules

### 0.0.1

**Commit Delta**: [Change from 0.0.0 release](https://github.com/plus3it/terraform-aws-tardigrade-config-rules/compare/0.0.0...0.0.1)

**Released**: 2019.09.04

**Summary**:

*   Vendoring community config rules provided by AWS

### 0.0.0

**Commit Delta**: N/A

**Released**: 2019.08.23

**Summary**:

*   Initial release!
