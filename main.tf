terraform {
  required_version = ">= 0.12"
}

resource "aws_elasticache_subnet_group" "elasticache_redis_cluster" {
  name       = "${var.name}-subnet"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_replication_group" "elasticache_redis_cluster" {
  at_rest_encryption_enabled    = var.at_rest_encryption_enabled
  auth_token                    = var.auth_token != "" ? var.auth_token : null
  auto_minor_version_upgrade    = var.auto_minor_version_upgrade
  automatic_failover_enabled    = var.automatic_failover_enabled
  engine_version                = var.engine_version
  kms_key_id                    = var.kms_key_id != "" ? var.kms_key_id : null
  maintenance_window            = var.maintenance_window
  multi_az_enabled              = var.multi_az_enabled
  node_type                     = var.node_type
  notification_topic_arn        = var.notification_topic_arn != "" ? var.notification_topic_arn : null
  number_cache_clusters         = var.number_of_nodes != "" ? var.number_of_nodes : null
  parameter_group_name          = var.parameter_group_name
  port                          = 6379
  replication_group_description = "Replication group for the ${var.name} cluster"
  replication_group_id          = "${var.name}-rg"
  security_group_ids            = [aws_security_group.elasticache_redis_cluster.id]
  snapshot_name                 = var.snapshot_name
  snapshot_retention_limit      = var.snapshot_retention_limit != "" ? var.snapshot_retention_limit : null
  snapshot_window               = var.snapshot_window != "" ? var.snapshot_window : null
  subnet_group_name             = aws_elasticache_subnet_group.elasticache_redis_cluster.name
  transit_encryption_enabled    = var.transit_encryption_enabled
  # Cluster mode configuration
  dynamic cluster_mode {
    for_each = var.automatic_failover_enabled != false ? [1] : []
    content {
      replicas_per_node_group = var.replicas_per_node_group
      num_node_groups         = var.num_node_groups
    }
  }

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
  )
}

resource "aws_security_group" "elasticache_redis_cluster" {
  name        = "${var.name}-security-group"
  description = "The security group used to manage access to the test redis cluster"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
  )
}

# Ingress Rule to permit inbound database port
resource "aws_security_group_rule" "in_redis_port" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  cidr_blocks       = var.cidr_blocks
  security_group_id = aws_security_group.elasticache_redis_cluster.id
}

# Egress Rule to permit outbound to given CIDR
resource "aws_security_group_rule" "outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.egress_cidr_blocks
  security_group_id = aws_security_group.elasticache_redis_cluster.id
}
