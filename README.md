# terraform-aws-tardigrade-config-rules

Terraform module to setup config rules

## Testing

Manual testing:

```
# Replace "xxx" with an actual AWS profile, then execute the integration tests.
export AWS_PROFILE=xxx 
make terraform/pytest PYTEST_ARGS="-v --nomock"
```

For automated testing, PYTEST_ARGS is optional and no profile is needed:

```
make mockstack/up
make terraform/pytest PYTEST_ARGS="-v"
make mockstack/clean
```

<!-- BEGIN TFDOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy.custom_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.custom_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config_recorder_id"></a> [config\_recorder\_id](#input\_config\_recorder\_id) | ID of the config recorder in the account. Required to address the implicit dependency on the config recorder | `string` | n/a | yes |
| <a name="input_config_rule"></a> [config\_rule](#input\_config\_rule) | Object of attributes for the config rule resource, see https://www.terraform.io/docs/providers/aws/r/config_config_rule.html#argument-reference. When `owner` is `AWS`, set `source_identifer` to the AWS predefined identifier for the rule. When `owner` is `CUSTOM_LAMBDA`, set `source_identifier` to `null` and it will be set to the ARN of the lambda function | <pre>object({<br/>    description                 = string<br/>    input_parameters            = string<br/>    maximum_execution_frequency = string<br/>    name                        = string<br/>    owner                       = string<br/>    source_identifier           = string<br/>    tags                        = map(string)<br/>    scope = object({<br/>      compliance_resource_id    = string<br/>      compliance_resource_types = list(string)<br/>      tag_key                   = string<br/>      tag_value                 = string<br/>    })<br/>    source_details = list(object({<br/>      message_type = string<br/>    }))<br/>  })</pre> | n/a | yes |
| <a name="input_lambda"></a> [lambda](#input\_lambda) | Object of attributes for the lambda supporting a custom config rule, see https://www.terraform.io/docs/providers/aws/r/lambda_function.html#argument-reference. Required when `config_rule.owner` is `CUSTOM_LAMBDA` | <pre>object({<br/>    description                    = string<br/>    handler                        = string<br/>    name                           = string<br/>    policy                         = string<br/>    runtime                        = string<br/>    source_path                    = string<br/>    reserved_concurrent_executions = number<br/>    tags                           = map(string)<br/>    timeout                        = number<br/>  })</pre> | <pre>{<br/>  "description": null,<br/>  "handler": null,<br/>  "name": null,<br/>  "policy": null,<br/>  "reserved_concurrent_executions": null,<br/>  "runtime": null,<br/>  "source_path": null,<br/>  "tags": null,<br/>  "timeout": null<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_config_rule"></a> [config\_rule](#output\_config\_rule) | AWS Config Rule object |

<!-- END TFDOCS -->
