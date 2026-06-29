
resource "google_access_context_manager_access_level" "ip" {
  count  = local.has_ip_level ? 1 : 0
  parent = "accessPolicies/${var.access_policy_name}"
  name   = "accessPolicies/${var.access_policy_name}/accessLevels/${var.perimeter_name}_ip"
  title  = "${var.perimeter_name} — allowed IP ranges"

  basic {
    conditions {
      ip_subnetworks = var.access_level_ip_ranges
    }
  }
}

resource "google_access_context_manager_access_level" "identities" {
  count  = local.has_identity_level ? 1 : 0
  parent = "accessPolicies/${var.access_policy_name}"
  name   = "accessPolicies/${var.access_policy_name}/accessLevels/${var.perimeter_name}_identities"
  title  = "${var.perimeter_name} — allowed identities"

  basic {
    conditions {
      members = var.access_level_identities
    }
  }
}
