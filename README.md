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
