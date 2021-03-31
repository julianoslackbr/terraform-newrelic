variable "name" {
	type = string
}

variable "incident_preference" {
  type = string
  default = "PER_CONDITION"
}

variable "channel_config" {
  type = list(map(string))
}