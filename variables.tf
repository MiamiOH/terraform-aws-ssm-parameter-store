# Retrieves data from AWS Systems Manager Parameter Store
#
# Useful for having data that is managed via AWS Systems Manager Parameter Store and shared with Puppet.
#
# Usage: miamioh_data([share:]path, name, initial_data, options = {})
# Example: $db_config = miamioh_data('DBA:oracle/db', 'appuser', {})
#
# More info here: https://git.itapps.miamioh.edu/operations/puppet/-/blob/master/doc/data/secure_data.md
#
variable "manage_parameters" {
  type        = bool
  default     = true
  description = "Whether or not to precreate and manage the ssm_parameters"
}

variable "update_parameters" {
  type        = bool
  default     = false
  description = "Whether or not to override changes and allow destroy on the ssm_parameters - only useful when manage_parameters"
}

variable "environment" {
  type        = string
  description = "The environment used. 'all' may be used here instead if the secret is the same in all environments"
  default     = ""
}

variable "default_share" {
  type        = string
  description = "The share to use when none is set"
  default     = ""
}

variable "parameters" {
  type        = any
  description = "A map of maps containing path for each item at minimum"
}

variable "additional_tags" {
  type    = map(string)
  default = {}
}

variable "module_tags" {
  type = map(string)
  default = {
    "Role" = "MiamiohData"
  }
}
