resource "aws_config_config_rule" "this" {
  name                        = var.config_rule.name
  description                 = var.config_rule.description
  input_parameters            = var.config_rule.input_parameters
  maximum_execution_frequency = var.config_rule.maximum_execution_frequency

  tags = merge(
    { Name = var.config_rule.name },
    var.config_rule.tags,
  )

  source {
    owner             = var.config_rule.owner
    source_identifier = local.custom_lambda ? module.custom_lambda[0].function_arn : var.config_rule.source_identifier

    dynamic "source_detail" {
      for_each = var.config_rule.source_details != null ? var.config_rule.source_details : []

      content {
        message_type = source_detail.value.message_type
      }
    }
  }

  dynamic "scope" {
    for_each = var.config_rule.scope != null ? [var.config_rule.scope] : []

    content {
      compliance_resource_id    = scope.value.compliance_resource_id
      compliance_resource_types = scope.value.compliance_resource_types
      tag_key                   = scope.value.tag_key
      tag_value                 = scope.value.tag_value
    }
  }

  depends_on = [
    aws_lambda_permission.custom_lambda,
    var.config_recorder_id,
  ]
}

module "custom_lambda" {
  count  = local.custom_lambda ? 1 : 0
  source = "git::https://github.com/plus3it/terraform-aws-lambda.git?ref=v1.3.0"

  function_name = var.lambda.name
  description   = var.lambda.description
  handler       = var.lambda.handler
  policy        = data.aws_iam_policy_document.custom_lambda[0]
  runtime       = var.lambda.runtime
  source_path   = var.lambda.source_path
  timeout       = var.lambda.timeout

  tags = merge(
    { Name = var.lambda.name },
    var.lambda.tags,
  )

  reserved_concurrent_executions = var.lambda.reserved_concurrent_executions
}

resource "aws_lambda_permission" "custom_lambda" {
  count = local.custom_lambda ? 1 : 0

  action         = "lambda:InvokeFunction"
  function_name  = module.custom_lambda[0].function_name
  principal      = "config.amazonaws.com"
  source_account = data.aws_caller_identity.this[0].account_id
}

data "aws_caller_identity" "this" {
  count = local.custom_lambda ? 1 : 0
}

data "aws_partition" "this" {
  count = local.custom_lambda ? 1 : 0
}

data "aws_iam_policy" "custom_lambda" {
  count = local.custom_lambda ? 1 : 0

  arn = "arn:${data.aws_partition.this[0].partition}:iam::aws:policy/service-role/AWSConfigRulesExecutionRole"
}

data "aws_iam_policy_document" "custom_lambda" {
  count = local.custom_lambda ? 1 : 0

  source_policy_documents   = compact([data.aws_iam_policy.custom_lambda[0].policy])
  override_policy_documents = compact([var.lambda.policy])
}

locals {
  custom_lambda = var.config_rule.owner == "CUSTOM_LAMBDA"
}
