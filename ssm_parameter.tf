# Manage resource
resource "aws_ssm_parameter" "miamioh_data" {
  for_each = local.manage_parameters_expanded

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [value]
  }

  name  = "/${join("/", compact([join("-", compact([each.value.environment, each.value.share])), trimprefix(each.value.path, "/"), each.value.name]))}"
  type  = "SecureString"
  value = yamlencode(each.value.initial_data)

  description = "Added by terraform aws_ssm_parameter"
  tags        = local.all_tags
}

# Manage resource with updates
resource "aws_ssm_parameter" "miamioh_data_update" {
  for_each = local.update_parameters_expanded

  name  = "/${join("/", compact([join("-", compact([each.value.environment, each.value.share])), trimprefix(each.value.path, "/"), each.value.name]))}"
  type  = "SecureString"
  value = yamlencode(each.value.initial_data)

  description = "Added by terraform aws_ssm_parameter with updates"
  overwrite   = true
  tags        = local.all_tags
}

# Just read the resource
data "aws_ssm_parameter" "miamioh_data" {
  for_each = local.parameters_expanded
  name     = "/${join("/", compact([join("-", compact([each.value.environment, each.value.share])), trimprefix(each.value.path, "/"), each.value.name]))}"
}

output "data" {
  value = merge(local.data_map, local.merge_data_map)

  sensitive = true
}
