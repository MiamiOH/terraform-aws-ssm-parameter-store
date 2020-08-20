locals {
  # Merge in defaults
  parameters_expanded = { for k, v in var.parameters : k => merge(
    {
      manage_parameter = var.manage_parameters
      environment      = var.environment
      share            = var.default_share
      name             = ""
      initial_data     = {}
    },
    v,
  ) }

  resource_parameters = { for k, v in local.parameters_expanded : k => v if v.manage_parameter }
  data_parameters     = { for k, v in local.parameters_expanded : k => v if ! v.manage_parameter }

  all_tags = merge(
    var.additional_tags,
    var.module_tags,
  )

  data_map = {
    for k, v in local.parameters_expanded :
    k => v.manage_parameter ? yamldecode(aws_ssm_parameter.miamioh_data[k].value) : yamldecode(data.aws_ssm_parameter.miamioh_data[k].value)
  }
}
