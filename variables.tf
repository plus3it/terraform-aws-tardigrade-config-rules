variable "config_recorder_id" {
  description = "ID of the config recorder in the account. Required to address the implicit dependency on the config recorder"
  type        = string
}

variable "config_rule" {
  description = "Object of attributes for the config rule resource, see https://www.terraform.io/docs/providers/aws/r/config_config_rule.html#argument-reference. When `owner` is `AWS`, set `source_identifer` to the AWS predefined identifier for the rule. When `owner` is `CUSTOM_LAMBDA`, set `source_identifier` to `null` and it will be set to the ARN of the lambda function"
  type = object({
    description                 = string
    input_parameters            = string
    maximum_execution_frequency = string
    name                        = string
    owner                       = string
    source_identifier           = string
    tags                        = map(string)
    scope = object({
      compliance_resource_id    = string
      compliance_resource_types = list(string)
      tag_key                   = string
      tag_value                 = string
    })
    source_details = list(object({
      message_type = string
    }))
  })
}

variable "lambda" {
  description = "Object of attributes for the lambda supporting a custom config rule, see https://www.terraform.io/docs/providers/aws/r/lambda_function.html#argument-reference. Required when `config_rule.owner` is `CUSTOM_LAMBDA`"
  default = {
    description                    = null
    handler                        = null
    name                           = null
    policy                         = null
    runtime                        = null
    source_path                    = null
    reserved_concurrent_executions = null
    tags                           = null
    timeout                        = null
  }
  type = object({
    description                    = string
    handler                        = string
    name                           = string
    policy                         = string
    runtime                        = string
    source_path                    = string
    reserved_concurrent_executions = number
    tags                           = map(string)
    timeout                        = number
  })
}
