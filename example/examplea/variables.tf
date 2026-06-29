variable "access_policy_name" {
  type        = string
  description = "Access policy name from bootstrap or policy module."

  validation {
    condition     = length(trimspace(var.access_policy_name)) > 0
    error_message = "access_policy_name must not be empty."
  }
}

variable "perimeter_name" {
  type        = string
  description = "Short name for the perimeter."

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]*$", var.perimeter_name))
    error_message = "perimeter_name must start with a letter and contain only letters, digits, and underscores."
  }
}

variable "project_numbers" {
  type        = list(string)
  description = "Project numbers to protect."

  validation {
    condition     = length(var.project_numbers) > 0
    error_message = "project_numbers must contain at least one entry."
  }
}

variable "restricted_services" {
  type        = list(string)
  description = "Services to restrict."

  validation {
    condition     = alltrue([for s in var.restricted_services : length(trimspace(s)) > 0])
    error_message = "Each restricted service must be a non-empty string."
  }
}

variable "corp_ip_ranges" {
  type        = list(string)
  description = "Corporate IP ranges to allow."
  default     = []

  validation {
    condition     = alltrue([for cidr in var.corp_ip_ranges : length(trimspace(cidr)) > 0])
    error_message = "Each corporate IP range must be a non-empty string."
  }
}
