# holden:ignore:HLD_TF_026 — examples intentionally use ../../ to reference the local module root
module "vpc_sc_perimeter" {
  source              = "../../"
  access_policy_name  = var.access_policy_name
  perimeter_name      = var.perimeter_name
  project_numbers     = var.project_numbers
  restricted_services = var.restricted_services
  access_level_ip_ranges = var.corp_ip_ranges
}
