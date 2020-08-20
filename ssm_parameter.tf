# Manage resource
resource "aws_ssm_parameter" "miamioh_data" {
  for_each = local.resource_parameters

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

# Just read the resource
data "aws_ssm_parameter" "miamioh_data" {
  for_each = local.data_parameters
  name     = "/${join("/", compact([join("-", compact([each.value.environment, each.value.share])), trimprefix(each.value.path, "/"), each.value.name]))}"
}

output "data" {
  value = local.data_map
}
