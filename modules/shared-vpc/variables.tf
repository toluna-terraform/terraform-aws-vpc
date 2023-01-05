variable "env_name" {
  type        = string
  nullable    = true
  default     = null
  description = "For backward compatibility only - will be removed in the future."
}

variable "shared_with_organization_unit" {
  type        = bool
  default     = false
}

variable "subnets" {
  type        = list(string)
  description = "List of subnets to share"
  default     = []
}
