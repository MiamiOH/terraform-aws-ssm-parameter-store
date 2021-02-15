locals {
  # Merge in defaults
  # https://github.com/hashicorp/terraform/issues/22263
  parameters_prexpanded = { for k, v in var.parameters : k => { for p in flatten([v.path]) : (length(flatten([v.path])) > 1 ? "${k}-${p}" : k) => merge(
    {
      manage_parameter = var.manage_parameters
      update_parameter = var.update_parameters
      environment      = var.environment
      share            = var.default_share
      name             = ""
      initial_data     = {}
    },
    v,
    { path = p },
  ) } }
  parameters_expanded = merge(flatten([[ for k, v in local.parameters_prexpanded : v ]])...)

  resource_parameters_m = { for k, v in local.parameters_expanded : k => v if v.manage_parameter && ! v.update_parameter }
  resource_parameters_u = { for k, v in local.parameters_expanded : k => v if v.update_parameter }
  data_parameters       = { for k, v in local.parameters_expanded : k => v if ! v.manage_parameter && ! v.update_parameter }

  all_tags = merge(
    var.additional_tags,
    var.module_tags,
  )

  data_map = {
    for k, v in local.parameters_prexpanded : k => merge([ for pk, pv in v :
    pv.update_parameter ? yamldecode(aws_ssm_parameter.miamioh_data_updates[pk].value) : pv.manage_parameter ? yamldecode(aws_ssm_parameter.miamioh_data[pk].value) : yamldecode(data.aws_ssm_parameter.miamioh_data[pk].value)
  ]...) }
}
