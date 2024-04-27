# ----------------------------------------
# Write your Terraform module outputs here
# ----------------------------------------
output "show_data" {
  value = [ for f in local.dns_records_data : f.zone ]
}