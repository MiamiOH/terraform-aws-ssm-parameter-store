locals {
  # Merge in defaults
  parameters_expanded = { for k, v in var.parameters : k => merge(
    {
      environment  = var.environment
      share        = var.default_share
      name         = ""
      initial_data = {}
    },
    v,
  ) }

  manage_parameters_expanded = { for k, v in var.manage_parameters : k => merge(
    {
      environment  = var.environment
      share        = var.default_share
      name         = ""
      initial_data = {}
    },
    v,
  ) }

  update_parameters_expanded = { for k, v in var.update_parameters : k => merge(
    {
      environment  = var.environment
      share        = var.default_share
      name         = ""
      initial_data = {}
    },
    v,
  ) }

  all_tags = merge(
    var.additional_tags,
    var.module_tags,
  )

  data_map = merge(
    { for k, v in local.parameters_expanded : k => yamldecode(data.aws_ssm_parameter.miamioh_data[k].value) },
    { for k, v in local.manage_parameters_expanded : k => yamldecode(aws_ssm_parameter.miamioh_data[k].value) if can(aws_ssm_parameter.miamioh_data[k]) },
    { for k, v in local.update_parameters_expanded : k => yamldecode(aws_ssm_parameter.miamioh_data_update[k].value) if can(aws_ssm_parameter.miamioh_data_update[k]) },
  )

  merge_data_map = {
    for k, v in var.merges : k => merge([for vk in v : local.data_map[vk]]...)
  }
}
