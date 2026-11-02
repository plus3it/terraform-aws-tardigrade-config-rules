# Agent Instructions

Before starting any task in this repository:

1. Run `make agents/sync`. It writes the shared Plus3 IT instructions for this repository's tardigrade-ci version to `.agents/plus3it/AGENTS.md`.
2. Read `.agents/plus3it/AGENTS.md` and follow it together with this file. If the sync fails, tell the user, and don't guess the conventions.

These rules always apply, even without the shared instructions:

- Don't push, open pull requests, publish releases, or apply infrastructure changes unless the user asks. List those steps for a person in your final report.
- Don't edit files under `.agents/plus3it/`; they are generated and overwritten by the sync.

@.agents/plus3it/AGENTS.md

## Repository-specific

### Purpose

This Terraform module creates one AWS Config rule. The main input is `config_rule`; when its `owner` is `CUSTOM_LAMBDA`, the module also creates a Lambda function from the `lambda` input, grants AWS Config permission to invoke it, and uses its ARN as the rule source. It also takes `config_recorder_id` to order the rule after the config recorder, and outputs the rule as `config_rule`.
