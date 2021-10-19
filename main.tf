terraform {
  required_version = ">= 0.12"
}

resource "aws_elasticache_subnet_group" "elasticache_redis_cluster" {
  name       = "${var.name}-subnet"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_replication_group" "elasticache_redis_cluster" {
  count                         = var.auth_required ? 0 : 1
  automatic_failover_enabled    = false
  replication_group_id          = "${var.name}-rg"
  replication_group_description = "Replication group for the ${var.name} cluster"
  node_type                     = var.node_type
  number_cache_clusters         = var.number_of_nodes
  engine_version                = var.engine_version
  parameter_group_name          = var.paramter_group_name

  security_group_ids         = [aws_security_group.elasticache_redis_cluster.id]
  subnet_group_name          = aws_elasticache_subnet_group.elasticache_redis_cluster.name
  port                       = 6379
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled
  auto_minor_version_upgrade = var.auto_minor_version_upgrade

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

resource "aws_elasticache_replication_group" "elasticache_redis_cluster_with_auth" {
  count                         = var.auth_required ? 1 : 0
  automatic_failover_enabled    = false
  replication_group_id          = "${var.name}-rg"
  replication_group_description = "Replication group for the ${var.name} cluster"
  node_type                     = var.node_type
  number_cache_clusters         = var.number_of_nodes
  engine_version                = var.engine_version
  parameter_group_name          = var.paramter_group_name
  security_group_ids            = [aws_security_group.elasticache_redis_cluster.id]
  subnet_group_name             = aws_elasticache_subnet_group.elasticache_redis_cluster.name
  port                          = 6379
  at_rest_encryption_enabled    = var.at_rest_encryption_enabled
  transit_encryption_enabled    = var.transit_encryption_enabled
  auto_minor_version_upgrade    = var.auto_minor_version_upgrade
  auth_token                    = var.auth_token

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
