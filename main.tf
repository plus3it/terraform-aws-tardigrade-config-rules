provider "aws" {}

locals {
  exclude_restricted_ssh                           = "${contains(var.exclude_rules, "restricted_ssh")}"
  exclude_cloudtrail_enabled                       = "${contains(var.exclude_rules, "cloudtrail_enabled")}"
  exclude_iam_password_policy                      = "${contains(var.exclude_rules, "iam_password_policy")}"
  exclude_s3_bucket_public_read_prohibited         = "${contains(var.exclude_rules, "s3_bucket_public_read_prohibited")}"
  exclude_s3_bucket_public_write_prohibited        = "${contains(var.exclude_rules, "s3_bucket_public_write_prohibited")}"
  exclude_s3_bucket_ssl_requests_only              = "${contains(var.exclude_rules, "s3_bucket_ssl_requests_only")}"
  exclude_codebuild_project_envvar_awscred_check   = "${contains(var.exclude_rules, "codebuild_project_envvar_awscred_check")}"
  exclude_codebuild_project_source_repo_url_check  = "${contains(var.exclude_rules, "codebuild_project_source_repo_url_check")}"
  exclude_instances_in_vpc                         = "${contains(var.exclude_rules, "instances_in_vpc")}"
  exclude_ec2_volume_inuse_check                   = "${contains(var.exclude_rules, "ec2_volume_inuse_check")}"
  exclude_eip_attached                             = "${contains(var.exclude_rules, "eip_attached")}"
  exclude_lambda_function_public_access_prohibited = "${contains(var.exclude_rules, "lambda_function_public_access_prohibited")}"
  exclude_restricted_incoming_traffic              = "${contains(var.exclude_rules, "restricted_incoming_traffic")}"
  exclude_root_account_mfa_enabled                 = "${contains(var.exclude_rules, "root_account_mfa_enabled")}"
  exclude_iam_access_key_rotation_check            = "${contains(var.exclude_rules, "iam_access_key_rotation_check")}"
  exclude_rds_vpc_public_subnet                    = "${contains(var.exclude_rules, "rds_vpc_public_subnet")}"
  exclude_iam_user_active                          = "${contains(var.exclude_rules, "iam_user_active")}"
  exclude_config_enabled                           = "${contains(var.exclude_rules, "config_enabled")}"
  exclude_iam_mfa_for_console_access               = "${contains(var.exclude_rules, "iam_mfa_for_console_access")}"
}

locals {
  aws_config_rules = "${path.root}/../../vendor/github.com/awslabs/aws-config-rules"
}

data "aws_partition" "current" {
  count = "${var.create_config_rules ? 1 : 0}"
}

data "aws_caller_identity" "this" {
  count = "${var.create_config_rules ? 1 : 0}"
}

data "template_file" "cloudtrail_enabled" {
  count = "${var.create_config_rules ? 1 : 0}"

  template = <<-EOF
            {"s3BucketName":"$${cloudtrail_bucket}"}
            EOF

  vars {
    cloudtrail_bucket = "${var.cloudtrail_bucket}"
  }
}

data "template_file" "iam_password_policy" {
  count = "${var.create_config_rules ? 1 : 0}"

  template = <<-EOF
            {
              "RequireUppercaseCharacters":"true",
              "RequireLowercaseCharacters":"true",
              "RequireSymbols":"true",
              "RequireNumbers":"true",
              "MinimumPasswordLength":"14",
              "PasswordReusePrevention":"24",
              "MaxPasswordAge":"60"
            }
            EOF
}

resource "aws_config_config_rule" "restricted_ssh" {
  count = "${var.create_config_rules && ! local.exclude_restricted_ssh ? 1 : 0}"

  name        = "restricted-ssh"
  description = "${var.config_recorder}"

  source {
    owner             = "AWS"
    source_identifier = "INCOMING_SSH_DISABLED"
  }
}

resource "aws_config_config_rule" "cloudtrail_enabled" {
  count = "${var.create_config_rules && ! local.exclude_cloudtrail_enabled ? 1 : 0}"

  name             = "cloudtrail-enabled"
  description      = "${var.config_recorder}"
  input_parameters = "${data.template_file.cloudtrail_enabled.rendered}"

  source {
    owner             = "AWS"
    source_identifier = "CLOUD_TRAIL_ENABLED"
  }
}

resource "aws_config_config_rule" "iam_password_policy" {
  count = "${var.create_config_rules && ! local.exclude_iam_password_policy ? 1 : 0}"

  name             = "iam-password-policy"
  description      = "${var.config_recorder}"
  input_parameters = "${data.template_file.iam_password_policy.rendered}"

  source {
    owner             = "AWS"
    source_identifier = "IAM_PASSWORD_POLICY"
  }
}

resource "aws_config_config_rule" "s3_bucket_public_read_prohibited" {
  count = "${var.create_config_rules && ! local.exclude_s3_bucket_public_read_prohibited ? 1 : 0}"

  name        = "s3-bucket-public-read-prohibited"
  description = "${var.config_recorder}"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }
}

resource "aws_config_config_rule" "s3_bucket_public_write_prohibited" {
  count = "${var.create_config_rules && ! local.exclude_s3_bucket_public_write_prohibited ? 1 : 0}"

  name        = "s3-bucket-public-write-prohibited"
  description = "${var.config_recorder}"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
  }
}

resource "aws_config_config_rule" "s3_bucket_ssl_requests_only" {
  count = "${var.create_config_rules && ! local.exclude_s3_bucket_ssl_requests_only ? 1 : 0}"

  name        = "s3-bucket-ssl-requests-only"
  description = "${var.config_recorder}"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_SSL_REQUESTS_ONLY"
  }
}

resource "aws_config_config_rule" "codebuild_project_envvar_awscred_check" {
  count = "${var.create_config_rules && ! local.exclude_codebuild_project_envvar_awscred_check ? 1 : 0}"

  name        = "codebuild-project-envvar-awscred-check"
  description = "${var.config_recorder}"

  source {
    owner             = "AWS"
    source_identifier = "CODEBUILD_PROJECT_ENVVAR_AWSCRED_CHECK"
  }
}

resource "aws_config_config_rule" "codebuild_project_source_repo_url_check" {
  count = "${var.create_config_rules && ! local.exclude_codebuild_project_source_repo_url_check ? 1 : 0}"

  name        = "codebuild-project-source-repo-url-check"
  description = "${var.config_recorder}"

  source {
    owner             = "AWS"
    source_identifier = "CODEBUILD_PROJECT_SOURCE_REPO_URL_CHECK"
  }
}

resource "aws_config_config_rule" "instances_in_vpc" {
  count = "${var.create_config_rules && ! local.exclude_instances_in_vpc ? 1 : 0}"

  name        = "instances-in-vpc"
  description = "${var.config_recorder}"

  source {
    owner             = "AWS"
    source_identifier = "INSTANCES_IN_VPC"
  }
}

resource "aws_config_config_rule" "ec2_volume_inuse_check" {
  count = "${var.create_config_rules && ! local.exclude_ec2_volume_inuse_check ? 1 : 0}"

  name        = "ec2-volume-inuse-check"
  description = "${var.config_recorder}"

  source {
    owner             = "AWS"
    source_identifier = "EC2_VOLUME_INUSE_CHECK"
  }
}

resource "aws_config_config_rule" "eip_attached" {
  count = "${var.create_config_rules && ! local.exclude_eip_attached ? 1 : 0}"

  name        = "eip-attached"
  description = "${var.config_recorder}"

  source {
    owner             = "AWS"
    source_identifier = "EIP_ATTACHED"
  }
}

resource "aws_config_config_rule" "lambda_function_public_access_prohibited" {
  count = "${var.create_config_rules && ! local.exclude_lambda_function_public_access_prohibited ? 1 : 0}"

  name        = "lambda-function-public-access-prohibited"
  description = "${var.config_recorder}"

  source {
    owner             = "AWS"
    source_identifier = "LAMBDA_FUNCTION_PUBLIC_ACCESS_PROHIBITED"
  }
}

resource "aws_config_config_rule" "restricted_incoming_traffic" {
  count = "${var.create_config_rules && ! local.exclude_restricted_incoming_traffic ? 1 : 0}"

  name        = "restricted-incoming-traffic"
  description = "${var.config_recorder}"

  input_parameters = <<-EOF
    {
      "blockedPort1": "3389"
    }
    EOF

  source {
    owner             = "AWS"
    source_identifier = "RESTRICTED_INCOMING_TRAFFIC"
  }
}

resource "aws_config_config_rule" "root_account_mfa_enabled" {
  count = "${var.create_config_rules && ! local.exclude_root_account_mfa_enabled ? 1 : 0}"

  name        = "root-account-mfa-enabled"
  description = "${var.config_recorder}"

  source {
    owner             = "AWS"
    source_identifier = "ROOT_ACCOUNT_MFA_ENABLED"
  }
}

# Custom config rules
data "aws_iam_policy" "config_rules" {
  count = "${var.create_config_rules ? 1 : 0}"

  arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSConfigRulesExecutionRole"
}

### iam_access_key_rotation_check
data "aws_iam_policy_document" "lambda_iam_access_key_rotation_check" {
  count = "${var.create_config_rules && ! local.exclude_iam_access_key_rotation_check ? 1 : 0}"

  source_json = "${data.aws_iam_policy.config_rules.policy}"

  statement {
    actions   = ["iam:ListAccessKeys"]
    resources = ["*"]
  }
}

module "lambda_iam_access_key_rotation_check" {
  source = "git::https://github.com/plus3it/terraform-aws-lambda.git?ref=v0.12.0"

  function_name = "config_rule_iam_access_key_rotation_check"
  description   = "Checks that IAM User Access Keys have been rotated within the specified number of days"
  handler       = "iam_access_key_rotation-triggered.handler"
  runtime       = "nodejs8.10"
  timeout       = 15
  tags          = "${var.tags}"

  reserved_concurrent_executions = "-1"

  source_path = "${local.aws_config_rules}/node/iam_access_key_rotation-triggered.js"

  attach_policy = "${var.create_config_rules && ! local.exclude_iam_access_key_rotation_check}"
  policy        = "${join("", data.aws_iam_policy_document.lambda_iam_access_key_rotation_check.*.json)}"
}

resource "aws_lambda_permission" "iam_access_key_rotation_check" {
  count = "${var.create_config_rules && ! local.exclude_iam_access_key_rotation_check ? 1 : 0}"

  action         = "lambda:InvokeFunction"
  function_name  = "${module.lambda_iam_access_key_rotation_check.function_name}"
  principal      = "config.amazonaws.com"
  source_account = "${data.aws_caller_identity.this.account_id}"
}

resource "aws_config_config_rule" "iam_access_key_rotation_check" {
  count = "${var.create_config_rules && ! local.exclude_iam_access_key_rotation_check ? 1 : 0}"

  name        = "iam-access-key-rotation-check"
  description = "${var.config_recorder}"

  input_parameters = <<-EOF
    {
      "MaximumAccessKeyAge": "90"
    }
    EOF

  scope {
    compliance_resource_types = ["AWS::IAM::User"]
  }

  source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = "${module.lambda_iam_access_key_rotation_check.function_arn}"

    source_detail {
      message_type = "ConfigurationItemChangeNotification"
    }

    source_detail {
      message_type = "OversizedConfigurationItemChangeNotification"
    }
  }

  depends_on = [
    "aws_lambda_permission.iam_access_key_rotation_check",
  ]
}

### rds_vpc_public_subnet
data "aws_iam_policy_document" "lambda_rds_vpc_public_subnet" {
  count = "${var.create_config_rules && ! local.exclude_rds_vpc_public_subnet ? 1 : 0}"

  source_json = "${data.aws_iam_policy.config_rules.policy}"

  statement {
    actions   = ["ec2:DescribeRouteTables"]
    resources = ["*"]
  }
}

module "lambda_rds_vpc_public_subnet" {
  source = "git::https://github.com/plus3it/terraform-aws-lambda.git?ref=v1.1.0"

  function_name = "config_rule_rds_vpc_public_subnet"
  description   = "Check that no RDS Instances are in a Public Subnet"
  handler       = "rds_vpc_public_subnet.lambda_handler"
  runtime       = "python3.6"
  timeout       = 15
  tags          = "${var.tags}"

  reserved_concurrent_executions = "-1"

  source_path = "${local.aws_config_rules}/python/rds_vpc_public_subnet.py"

  attach_policy = "${var.create_config_rules && ! local.exclude_rds_vpc_public_subnet}"
  policy        = "${join("", data.aws_iam_policy_document.lambda_rds_vpc_public_subnet.*.json)}"
}

resource "aws_lambda_permission" "rds_vpc_public_subnet" {
  count = "${var.create_config_rules && ! local.exclude_rds_vpc_public_subnet ? 1 : 0}"

  action         = "lambda:InvokeFunction"
  function_name  = "${module.lambda_rds_vpc_public_subnet.function_name}"
  principal      = "config.amazonaws.com"
  source_account = "${data.aws_caller_identity.this.account_id}"
}

resource "aws_config_config_rule" "rds_vpc_public_subnet" {
  count = "${var.create_config_rules && ! local.exclude_rds_vpc_public_subnet ? 1 : 0}"

  name        = "rds-vpc-public-subnet"
  description = "${var.config_recorder}"

  scope {
    compliance_resource_types = ["AWS::RDS::DBInstance"]
  }

  source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = "${module.lambda_rds_vpc_public_subnet.function_arn}"

    source_detail {
      message_type = "ConfigurationItemChangeNotification"
    }

    source_detail {
      message_type = "OversizedConfigurationItemChangeNotification"
    }
  }

  depends_on = [
    "aws_lambda_permission.rds_vpc_public_subnet",
  ]
}

### iam_user_active
data "aws_iam_policy_document" "lambda_iam_user_active" {
  count = "${var.create_config_rules && ! local.exclude_iam_user_active ? 1 : 0}"

  source_json = "${data.aws_iam_policy.config_rules.policy}"

  statement {
    actions = [
      "iam:GetUser",
      "iam:ListAccessKeys",
      "iam:GetAccessKeyLastUsed",
    ]

    resources = ["*"]
  }
}

module "lambda_iam_user_active" {
  source = "git::https://github.com/plus3it/terraform-aws-lambda.git?ref=v0.12.0"

  function_name = "config_rule_iam_user_active"
  description   = "Checks if IAM users are active"
  handler       = "IAM_USER_USED_LAST_90_DAYS.lambda_handler"
  runtime       = "python3.6"
  timeout       = 15
  tags          = "${var.tags}"

  reserved_concurrent_executions = "-1"

  source_path = "${local.aws_config_rules}/python/IAM_USER_USED_LAST_90_DAYS/IAM_USER_USED_LAST_90_DAYS.py"

  attach_policy = "${var.create_config_rules && ! local.exclude_iam_user_active}"
  policy        = "${join("", data.aws_iam_policy_document.lambda_iam_user_active.*.json)}"
}

resource "aws_lambda_permission" "iam_user_active" {
  count = "${var.create_config_rules && ! local.exclude_iam_user_active ? 1 : 0}"

  action         = "lambda:InvokeFunction"
  function_name  = "${module.lambda_iam_user_active.function_name}"
  principal      = "config.amazonaws.com"
  source_account = "${data.aws_caller_identity.this.account_id}"
}

resource "aws_config_config_rule" "iam_user_active" {
  count = "${var.create_config_rules && ! local.exclude_iam_user_active ? 1 : 0}"

  name        = "iam-user-active"
  description = "${var.config_recorder}"

  input_parameters = <<-EOF
    {
      "NotUsedTimeOutInDays": "90"
    }
    EOF

  scope {
    compliance_resource_types = ["AWS::IAM::User"]
  }

  source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = "${module.lambda_iam_user_active.function_arn}"

    source_detail {
      message_type = "ConfigurationItemChangeNotification"
    }

    source_detail {
      message_type = "OversizedConfigurationItemChangeNotification"
    }
  }

  depends_on = [
    "aws_lambda_permission.iam_user_active",
  ]
}

### config_enabled
module "lambda_config_enabled" {
  source = "git::https://github.com/plus3it/terraform-aws-lambda.git?ref=v0.12.0"

  function_name = "config_rule_config_enabled"
  description   = "Checks that Config has been activated and is logging to a specific bucket and sending to a specifc SNS topic"
  handler       = "config_enabled.lambda_handler"
  runtime       = "python3.6"
  timeout       = 15
  tags          = "${var.tags}"

  reserved_concurrent_executions = "-1"

  source_path = "${local.aws_config_rules}/python/config_enabled.py"

  attach_policy = "${var.create_config_rules && ! local.exclude_config_enabled}"
  policy        = "${join("", data.aws_iam_policy.config_rules.*.policy)}"
}

resource "aws_lambda_permission" "config_enabled" {
  count = "${var.create_config_rules && ! local.exclude_config_enabled ? 1 : 0}"

  action         = "lambda:InvokeFunction"
  function_name  = "${module.lambda_config_enabled.function_name}"
  principal      = "config.amazonaws.com"
  source_account = "${data.aws_caller_identity.this.account_id}"
}

resource "aws_config_config_rule" "config_enabled" {
  count = "${var.create_config_rules && ! local.exclude_config_enabled ? 1 : 0}"

  name        = "config-enabled"
  description = "${var.config_recorder}"

  input_parameters = <<-EOF
    {
      "s3BucketName": "${var.config_bucket}",
      "snsTopicARN": "${var.config_sns_topic_arn}"
    }
    EOF

  scope {
    compliance_resource_types = ["AWS::IAM::User"]
  }

  source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = "${module.lambda_config_enabled.function_arn}"

    source_detail {
      message_type = "ScheduledNotification"
    }
  }

  depends_on = [
    "aws_lambda_permission.config_enabled",
  ]
}

### iam_mfa_for_console_access
data "aws_iam_policy_document" "lambda_iam_mfa_for_console_access" {
  count = "${var.create_config_rules && ! local.exclude_iam_mfa_for_console_access ? 1 : 0}"

  source_json = "${data.aws_iam_policy.config_rules.policy}"

  statement {
    actions = [
      "iam:ListMFADevices",
      "iam:GetLoginProfile",
    ]

    resources = ["*"]
  }
}

module "lambda_iam_mfa_for_console_access" {
  source = "git::https://github.com/plus3it/terraform-aws-lambda.git?ref=v0.12.0"

  function_name = "config_rule_iam_mfa_for_console_access"
  description   = "Checks that all IAM users with console access have at least one MFA device"
  handler       = "iam_mfa_for_console_access.lambda_handler"
  runtime       = "python3.6"
  timeout       = 15
  tags          = "${var.tags}"

  reserved_concurrent_executions = "-1"

  source_path = "${local.aws_config_rules}/python/iam_mfa_for_console_access.py"

  attach_policy = "${var.create_config_rules && ! local.exclude_iam_mfa_for_console_access}"
  policy        = "${join("", data.aws_iam_policy_document.lambda_iam_mfa_for_console_access.*.json)}"
}

resource "aws_lambda_permission" "iam_mfa_for_console_access" {
  count = "${var.create_config_rules && ! local.exclude_iam_mfa_for_console_access ? 1 : 0}"

  action         = "lambda:InvokeFunction"
  function_name  = "${module.lambda_iam_mfa_for_console_access.function_name}"
  principal      = "config.amazonaws.com"
  source_account = "${data.aws_caller_identity.this.account_id}"
}

resource "aws_config_config_rule" "iam_mfa_for_console_access" {
  count = "${var.create_config_rules && ! local.exclude_iam_mfa_for_console_access ? 1 : 0}"

  name        = "iam-mfa-for-console-access"
  description = "${var.config_recorder}"

  scope {
    compliance_resource_types = ["AWS::IAM::User"]
  }

  source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = "${module.lambda_iam_mfa_for_console_access.function_arn}"

    source_detail {
      message_type = "ConfigurationItemChangeNotification"
    }

    source_detail {
      message_type = "OversizedConfigurationItemChangeNotification"
    }
  }

  depends_on = [
    "aws_lambda_permission.iam_mfa_for_console_access",
  ]
}
