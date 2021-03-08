# Retrieves data from AWS Systems Manager Parameter Store
#
# Useful for having data that is managed via AWS Systems Manager Parameter Store and shared with Puppet.
#
# Usage: miamioh_data([share:]path, name, initial_data, options = {})
# Example: $db_config = miamioh_data('DBA:oracle/db', 'appuser', {})
#
# More info here: https://git.itapps.miamioh.edu/operations/puppet/-/blob/master/doc/data/secure_data.md
#
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
  description = "A map of maps containing path for each item at minimum. These parameters are read only"
  default     = {}
}

variable "manage_parameters" {
  type        = any
  description = "A map of maps containing path for each item at minimum. These parameters precreate and manage the ssm_parameters"
  default     = {}
}

variable "update_parameters" {
  type        = any
  description = "A map of maps containing path for each item at minimum. These parameters override changes and allow destroy on the ssm_parameters - implies manage_parameters"
  default     = {}
}

variable "merges" {
  type        = map(list(string))
  description = "A map of items you would like merged"
  default     = {}
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
