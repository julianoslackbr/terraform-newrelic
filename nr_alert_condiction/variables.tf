# variable "policy_id" {
#   type = string
# }

variable "condiction_type" {
  type = string
	default = "static"
}

variable "name" {
	type = string
}

variable "description" {
	type = string
}

# variable "runbook_url" {
# 	type = string
# }

variable "value_function" {
	type = string
	default = "single_value"
}

variable "violation_time_limit_seconds" {
	type = number
	default = 3600
}

variable "nqrl_query" {
	type = string
}

variable "critical" {
  type = list(map(string))
  default = [{}]
}


# variable "warning" {
#   type = list(map(string))
#   default =  [{ 
#         operator              = ""
#         threshold             = ""
#         threshold_duration    = ""
#         threshold_occurrences = ""
# 	}]
# }
variable "warning" {
  type = list(map(string))
  default = null
}

variable "nr_policy" {
  type = string
}