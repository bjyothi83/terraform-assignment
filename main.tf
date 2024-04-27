/**
* # Terraform
*
* <Short TF module description>
*
*
* ## Usage
*
* ### Quick Example
*
* ```hcl
* module "dns_" {
*   source = ""
*   input1 = <>
*   input2 = <>
* } 
* ```
*
*/
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ---------------------------------------------------------------------------------------------------------------------
# SET TERRAFORM RUNTIME REQUIREMENTS
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
  # This module is now only being tested with Terraform 0.13.x. However, to make upgrading easier, we are setting
  # 0.12.26 as the minimum version, as that version added support for required_providers with source URLs, making it
  # forwards compatible with 0.13.x code.
  required_version = ">= 0.13.5"
  required_providers {
    dns = {
      source  = "hashicorp/dns"
      version = ">= 3.2.0"
    }
  }
}


# ------------------------------------------
# Write your local resources here
# ------------------------------------------

locals {
  dns_records_files = fileset(path.module, "/examples/exercise/input-json/*.json")
  dns_records_data  = [ for file in local.dns_records_files : jsondecode(file("${path.module}/${file}")) ]
}

# ------------------------------------------
# Write your Terraform resources here
# ------------------------------------------

resource "dns_a_record_set" "www" {
  for_each  =  { for r in local.dns_records_data : r.ttl => r }
  zone = each.value.zone
  name = var.name
  addresses = each.value.addresses
  ttl = each.value.ttl
}
