variable "project" {
  type        = string
  description = "The GCP project identifier where the secret will be created."
}

variable "secret_id" {
  type        = string
  description = "The secret identifier to create; this value must be unique within the project."
}

variable "replication_locations" {
  type        = list(string)
  description = "An optional list of replication locations for the secret. If the value is an empty list (default) then an automatic replication policy will be applied."
  default     = []
}

variable "secret" {
  type        = string
  description = "The secret payload to store in Secret Manager. Binary values should be base64 encoded before use."
  default     = ""
}

variable "accessors" {
  type = list(string)
  validation {
    condition     = length(join("", [for acct in var.accessors : can(regex("^(?:group|serviceAccount|user):[^@]+@[^@]*$", acct)) ? "x" : ""])) == length(var.accessors)
    error_message = "Each accessors value must be a valid IAM account identifier; e.g. user:jdoe@company.com, group:admins@company.com, serviceAccount:service@project.iam.gserviceaccount.com."
  }
  description = "An optional list of IAM account identifiers that will be granted accessor (read-only) permission to the secret."
  default     = []
}

variable "labels" {
  type        = map(string)
  description = "An optional map of label key:value pairs to assign to the secret resources."
  default     = {}
}

variable "length" {
  type        = number
  description = "The length of the random string to generate for secret value. Default is 16."
  validation {
    condition     = floor(var.length) == var.length && var.length >= 1
    error_message = "Generated secret length must be an integer greater than zero."
  }
  default = 16
}

variable "has_lower_chars" {
  type        = bool
  description = "Include lowercase characters in the generated secret."
  default     = true
}

variable "min_lower_chars" {
  type        = number
  description = "The minimum number of lowercase characters to include in the generated secret."
  default     = 0
}

variable "has_upper_chars" {
  type        = bool
  description = "Include uppercase characters in the generated secret."
  default     = true
}

variable "min_upper_chars" {
  type        = number
  description = "The minimum number of uppercase characters to include in the generated secret."
  default     = 0
}

variable "has_numeric_chars" {
  type        = bool
  description = "Include numeric characters in the generated secret."
  default     = true
}

variable "min_numeric_chars" {
  type        = number
  description = "The minimum number of numeric characters to include in the generated secret."
  default     = 0
}

variable "has_special_chars" {
  type        = bool
  description = "Include special characters in the generated secret."
  default     = true
}

variable "min_special_chars" {
  type        = number
  description = "The minimum number of special characters to include in the generated secret."
  default     = 0
}
