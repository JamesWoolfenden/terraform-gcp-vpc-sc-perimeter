locals {
  has_ip_level       = length(var.access_level_ip_ranges) > 0
  has_identity_level = length(var.access_level_identities) > 0
  access_level_names = concat(
    local.has_ip_level ? [google_access_context_manager_access_level.ip[0].name] : [],
    local.has_identity_level ? [google_access_context_manager_access_level.identities[0].name] : [],
  )
  perimeter_config = {
    resources           = var.project_numbers
    restricted_services = var.restricted_services
    access_levels       = local.access_level_names
  }
}
