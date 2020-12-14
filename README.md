# terraform-aws-ssm-parameter-store
Terraform module to work with AWS Systems Manager (SSM) Parameter Store

## Usage

```hcl
module "miamioh_data" {
  source      = "git::https://github.com/MiamiOH/terraform-aws-ssm-parameter-store?ref=master"
  environment = "test"

  parameters = {
    "provider_infoblox_internal" = {
      manage_parameter = false
      environment      = "all"
      share            = "Networking"
      path             = "provider/infoblox/internal"
    }
  }
}
```

```hcl
module "miamioh_data" {
  source      = "git::https://github.com/MiamiOH/terraform-aws-ssm-parameter-store?ref=master"

  parameters = {
    "provider_infoblox_internal" = {
      manage_parameter = false
      path             = "/all-Networking/provider/infoblox/internal"
    }
  }
}

```

AWS Parameter store has a limit on chars for the Standard (free) parameters. It is a frequent pattern that we break up our data into several parameters and merge them together. This module can handle the merging for you if you specify a list of paths.

``hcl
module "miamioh_data" {
  source      = "git::https://github.com/MiamiOH/terraform-aws-ssm-parameter-store?ref=master"
  environment = "test"

  parameters = {
    "puppetca" = {
      share = "Linux"
      path  = [
        "puppet/ssl/certs/ca.pem",
        "puppet/ssl/certs/foo.com.pem",
        "puppet/ssl/private_keys/foo.com.pem",
      ]
      initial_data = {
        "uri"  = "https://puppet:8140"
        "ca"   = null
        "cert" = null
        "key"  = null
      }
    }
  }
}
```
