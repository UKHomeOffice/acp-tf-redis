variable "name" {
  description = "A descriptive name for the redis cluster"
}

variable "environment" {
  description = "The environment the redis cluster is running in i.e. dev, prod etc"
}

variable "number_of_nodes" {
  description = "The number of nodes in this cluster"
  default     = ""
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
  type        = bool
  default     = false
}

variable "auth_token" {
  description = "The password for redis AUTH"
  default     = ""
}

variable "cidr_blocks" {
  description = "cidr blocks from which this cluster should accept connections"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "engine_version" {
  description = "The engine version for this cluster"
  default     = "4.0.10"
}

variable "parameter_group_name" {
  description = "The parameter group name for this cluster"
  default     = "default.redis4.0"
}

variable "auto_minor_version_upgrade" {
  description = "Should the cluster autmoatically be updated to the latest minor vesrion"
  type        = bool
  default     = false
}

variable "replicas_per_node_group" {
  description = "Set for cluster mode: the number of replica nodes in each node group (required if using cluster mode)"
  default     = ""
}

variable "num_node_groups" {
  description = "Set for cluster mode: the number of node groups (shards) for this Redis replication group (required if using cluster mode)"
  default     = ""
}

variable "notification_topic_arn" {
  description = "The ARN of an SNS topic to send Elasticache notifications to"
  default     = ""
}

variable "snapshot_name" {
  description = "The name of a snapshot from which to restore data into the new node group. (Changing the snapshot_name forces a new resource)."
  default     = ""
}

variable "snapshot_window" {
  description = "The daily time range which ElastiCache will begin taking daily snapshots"
  default     = ""
}

variable "snapshot_retention_limit" {
  description = "Redis only: the retention period of snapshots kept in days"
  default     = ""
}

variable "automatic_failover_enabled" {
  description = "Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. Must be enabled for Redis (cluster mode enabled) replication groups."
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. Can be specified only if at_rest_encryption_enabled is true"
  default     = ""
}

variable "maintenance_window" {
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period."
  default     = "sun:05:00-sun:09:00"
}

variable "multi_az_enabled" {
  description = "Enable multi-az for this instance"
  type        = bool
  default     = false
}

variable "egress_cidr_blocks" {
  description = "Cidr blocks which this cluster should allow egress traffic to"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
