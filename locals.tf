locals {
  # Merge in defaults
  # https://github.com/hashicorp/terraform/issues/22263
  parameters_prexpanded = { for k, v in var.parameters : k => { for p in flatten([v]) : (length(flatten([v])) > 1 ? "${k}-${p.path}" : k) => merge(
    {
      manage_parameter = var.manage_parameters
      environment      = var.environment
      share            = var.default_share
      name             = ""
      initial_data     = {}
    },
    p,
  ) } }
  parameters_expanded = merge(flatten([[for k, v in local.parameters_prexpanded : v]])...)

  update_parameters_prexpanded = { for k, v in var.update_parameters : k => { for p in flatten([v]) : (length(flatten([v])) > 1 ? "${k}-${p.path}" : k) => merge(
    {
      environment      = var.environment
      share            = var.default_share
      name             = ""
      initial_data     = {}
    },
    p,
  ) } }
  update_parameters_expanded = merge(flatten([[for k, v in local.update_parameters_prexpanded : v]])...)

  resource_parameters = { for k, v in local.parameters_expanded : k => v if v.manage_parameter }
  data_parameters     = { for k, v in local.parameters_expanded : k => v if ! v.manage_parameter }

  all_tags = merge(
    var.additional_tags,
    var.module_tags,
  )

  data_map = {
    for k, v in local.parameters_prexpanded : k => merge([for pk, pv in v :
      pv.manage_parameter ? yamldecode(aws_ssm_parameter.miamioh_data[pk].value) : yamldecode(data.aws_ssm_parameter.miamioh_data[pk].value)
  ]...) }

  update_data_map = {
    for k, v in local.update_parameters_prexpanded : k => merge([for pk, pv in v :
      yamldecode(aws_ssm_parameter.miamioh_data_updates[pk].value)
  ]...) }
}
