resource "aws_elasticache_subnet_group" "elasticache_redis_cluster" {
  name       = "${var.name}-subnet"
  subnet_ids = ["${var.subnet_ids}"]
}

resource "aws_elasticache_replication_group" "elasticache_redis_cluster" {
  count                         = "${1 - var.auth_required}"
  automatic_failover_enabled    = false
  replication_group_id          = "${var.name}-rg"
  replication_group_description = "Replication group for the ${var.name} cluster"
  node_type                     = "${var.node_type}"
  number_cache_clusters         = "${var.number_of_nodes}"
  engine_version                = "${var.engine_version}"
  parameter_group_name          = "${var.paramter_group_name}"

  security_group_ids         = ["${aws_security_group.elasticache_redis_cluster.id}"]
  subnet_group_name          = "${aws_elasticache_subnet_group.elasticache_redis_cluster.name}"
  port                       = 6379
  at_rest_encryption_enabled = "${var.at_rest_encryption_enabled}"
  transit_encryption_enabled = "${var.transit_encryption_enabled}"
  auto_minor_version_upgrade = "${var.auto_minor_version_upgrade}"

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.environment, var.name)), map("Env", var.environment))}"
}

resource "aws_elasticache_replication_group" "elasticache_redis_cluster_with_auth" {
  count                         = "${0 + var.auth_required}"
  automatic_failover_enabled    = false
  replication_group_id          = "${var.name}-rg"
  replication_group_description = "Replication group for the ${var.name} cluster"
  node_type                     = "${var.node_type}"
  number_cache_clusters         = "${var.number_of_nodes}"
  engine_version                = "${var.engine_version}"
  parameter_group_name          = "${var.paramter_group_name}"
  security_group_ids            = ["${aws_security_group.elasticache_redis_cluster.id}"]
  subnet_group_name             = "${aws_elasticache_subnet_group.elasticache_redis_cluster.name}"
  port                          = 6379
  at_rest_encryption_enabled    = "${var.at_rest_encryption_enabled}"
  transit_encryption_enabled    = "${var.transit_encryption_enabled}"
  auto_minor_version_upgrade    = "${var.auto_minor_version_upgrade}"
  auth_token                    = "${var.auth_token}"

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.environment, var.name)), map("Env", var.environment))}"
}

resource "aws_security_group" "elasticache_redis_cluster" {
  name        = "${var.name}-security-group"
  description = "The security group used to manage access to the test redis cluster"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.environment, var.name)), map("Env", var.environment))}"
}

# Ingress Rule to permit inbound database port
resource "aws_security_group_rule" "in_redis_port" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  cidr_blocks       = ["${var.cidr_blocks}"]
  security_group_id = "${aws_security_group.elasticache_redis_cluster.id}"
}

# Egress Rule to permit outbound to all
resource "aws_security_group_rule" "out_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.elasticache_redis_cluster.id}"
}
