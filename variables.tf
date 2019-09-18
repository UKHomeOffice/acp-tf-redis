variable "name" {
  description = "A descriptive name for the redis cluster"
}

variable "environment" {
  description = "The environment the redis cluster is running in i.e. dev, prod etc"
}

variable "number_of_nodes" {
  description = "The number of nodes in this cluster"
  default     = 1
}

variable "node_type" {
  description = "The type of nodes to use for this cluster"
}

variable "vpc_id" {
  description = "The VPC ID to create the resources within"
}

variable "subnet_ids" {
  description = "The list of subnet IDs associated to a vpc"
  default     = []
}

variable "at_rest_encryption_enabled" {
  description = "Should at rest encrption be enabled for this cluster"
  default     = false
}

variable "transit_encryption_enabled" {
  description = "Should transit encryption be enabled for this cluster"
  default     = false
}

variable "auth_token" {
  description = "The password for redis AUTH"
  default     = ""
}

variable "auth_required" {
  description = "Should redis AUTH be enabled for this cluster"
  default     = false
}

variable "cidr_blocks" {
  description = "cidr blocks from which this cluster should accept connections"
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "engine_version" {
  description = "The engine version for this cluster"
  default     = "4.0.10"
}

variable "paramter_group_name" {
  description = "The parameter group name for this cluster"
  default     = "default.redis4.0"
}

variable "auto_minor_version_upgrade" {
  description = "Should the cluster autmoatically be updated to the latest minor vesrion"
  default     = false
}

