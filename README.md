# acp-tf-redis
Terraform module to build redis elasticache clusters

## Module Usage

```
module "fake_redis" {
  source = "git::https://github.com/UKHomeOffice/acp-tf-redis?ref=v0.0.1"

  name                       = "fake-redis"
  environment                = "${var.environment}"
  node_type                  = "cache.t2.small"
  number_of_nodes            = 2
  cidr_blocks                = "${values(var.compute_cidrs)}"
  subnet_ids                 = ["${var.subnet_ids}"]
  vpc_id                     = "${var.vpc_id}"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| at\_rest\_encryption\_enabled | Should at rest encrption be enabled for this cluster | string | `false` | no |
| auth\_required | Should redis AUTH be enabled for this cluster | string | `false` | no |
| auth\_token | The password for redis AUTH | string | `` | no |
| auto\_minor\_version\_upgrade | Should the cluster autmoatically be updated to the latest minor vesrion | string | `false` | no |
| automatic_failover_enabled | Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. Must be enabled for Redis (cluster mode enabled) replication groups. | string | `false` | no |
| cidr\_blocks | cidr blocks from which this cluster should accept connections | list | `<list>` | no |
| engine\_version | The engine version for this cluster | string | `4.0.10` | no |
| environment | The environment the redis cluster is running in i.e. dev, prod etc | string | - | yes |
| kms_key_id | The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. Can be specified only if at_rest_encryption_enabled is true | string | - | no |
| name | A descriptive name for the redis cluster | string | - | yes |
| node\_type | The type of nodes to use for this cluster | string | - | yes |
| notification\_topic\_arn | The ARN of an SNS topic to send Elasticache notifications to | string | - | no |
| num\_node\_groups | For cluster mode: the number of node groups (shards) for this Redis replication group (required if using cluster mode) | string | - | no |
| number\_of\_nodes | The number of nodes in this cluster | string | `1` | no |
| parameter\_group\_name | The parameter group name for this cluster | string | `default.redis4.0` | no |
| replicas\_per\_node\_group | For cluster mode: the number of replica nodes in each node group (required if using cluster mode)| string | - | no |
| snapshot\_retention\_limit | Redis only: the retention period of snapshots kept in days | string | - | no |
| snapshot\_window | The daily time range which ElastiCache will begin taking daily snapshots | string | - | no |
| subnet\_ids | The list of subnet IDs associated to a vpc | list | `<list>` | no |
| tags | A map of tags to add to all resources | map | `<map>` | no |
| transit\_encryption\_enabled | Should transit encryption be enabled for this cluster | string | `false` | no |
| vpc\_id | The VPC ID to create the resources within | string | - | yes |
