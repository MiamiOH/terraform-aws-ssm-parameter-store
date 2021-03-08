# terraform-aws-ssm-parameter-store
Terraform module to work with AWS Systems Manager (SSM) Parameter Store

## Usage

Just read a parameter

```hcl
module "miamioh_data" {
  source      = "git::https://github.com/MiamiOH/terraform-aws-ssm-parameter-store?ref=master"
  environment = "test"

  parameters = {
    "provider_infoblox_internal" = {
      environment = "all"
      share       = "Networking"
      path        = "provider/infoblox/internal"
    }
  }
}
```

Don't use environment and share (just specify the full path)

```hcl
module "miamioh_data" {
  source = "git::https://github.com/MiamiOH/terraform-aws-ssm-parameter-store?ref=master"

  parameters = {
    "provider_infoblox_internal" = {
      path = "/all-Networking/provider/infoblox/internal"
    }
  }
}

```

AWS Parameter store has a limit on chars for the Standard (free) parameters. It is a frequent pattern that we break up our data into several parameters and merge them together. This module can handle the merging for you if you specify the merges you want.

```hcl
module "miamioh_data" {
  source      = "git::https://github.com/MiamiOH/terraform-aws-ssm-parameter-store?ref=master"
  environment = "test"

  manage_parameters = {
    "puppetca_ca" = {
      share = "Linux"
      path  = "puppet/ssl/certs/ca.pem"
      initial_data = {
        "uri" = "https://puppet:8140"
        "ca"  = null
      }
    }
    "puppetca_cert" = {
      share = "Linux"
      path  = "puppet/ssl/certs/foo.com.pem"
      initial_data = {
        "cert" = null
      }
    }
    "puppetca_key" = {
      share = "Linux"
      path  = "puppet/ssl/private_keys/foo.com.pem"
      initial_data = {
        "key" = null
      }
    }
  }
  merges = {
    "puppetca" = ["puppetca_ca", "puppetca_cert", "puppetca_key"]
  }
}
```
