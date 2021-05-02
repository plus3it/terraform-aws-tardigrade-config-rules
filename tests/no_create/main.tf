provider "aws" {
  region = "us-east-1"
}


module "no_create" {
  source = "../../"
  count  = 0

  config_recorder_id = null
  config_rule = {
    description                 = null
    input_parameters            = null
    maximum_execution_frequency = null
    name                        = null
    owner                       = null
    scope                       = null
    source_details              = null
    source_identifier           = null
    tags                        = null
  }
}

output "no_create" {
  description = "Module object from no_create"
  value       = module.no_create
}
