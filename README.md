# terraform-aws-tardigrade-config-rules

Terraform module to setup config rules

## AWS Labs Config Rules
* The community config rules provided by AWS are included in this repository. If the rules are out of date you can regenerate them with the following commands
```Makefile
make clean && make vendor
```


<!-- BEGIN TFDOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| config\_recorder\_id | ID of the config recorder in the account. Required to address the implicit dependency on the config recorder | `string` | n/a | yes |
| config\_rule | Object of attributes for the config rule resource, see https://www.terraform.io/docs/providers/aws/r/config_config_rule.html#argument-reference. When `owner` is `AWS`, set `source_identifer` to the AWS predefined identifier for the rule. When `owner` is `CUSTOM_LAMBDA`, set `source_identifier` to `null` and it will be set to the ARN of the lambda function | <pre>object({<br>    description                 = string<br>    input_parameters            = string<br>    maximum_execution_frequency = string<br>    name                        = string<br>    owner                       = string<br>    source_identifier           = string<br>    tags                        = map(string)<br>    scope = object({<br>      compliance_resource_id    = string<br>      compliance_resource_types = list(string)<br>      tag_key                   = string<br>      tag_value                 = string<br>    })<br>    source_details = list(object({<br>      message_type = string<br>    }))<br>  })</pre> | n/a | yes |
| lambda | Object of attributes for the lambda supporting a custom config rule, see https://www.terraform.io/docs/providers/aws/r/lambda_function.html#argument-reference. Required when `config_rule.owner` is `CUSTOM_LAMBDA` | <pre>object({<br>    description                    = string<br>    handler                        = string<br>    name                           = string<br>    policy                         = string<br>    runtime                        = string<br>    source_path                    = string<br>    reserved_concurrent_executions = number<br>    tags                           = map(string)<br>    timeout                        = number<br>  })</pre> | <pre>{<br>  "description": null,<br>  "handler": null,<br>  "name": null,<br>  "policy": null,<br>  "reserved_concurrent_executions": null,<br>  "runtime": null,<br>  "source_path": null,<br>  "tags": null,<br>  "timeout": null<br>}</pre> | no |

## Outputs

No output.

<!-- END TFDOCS -->
