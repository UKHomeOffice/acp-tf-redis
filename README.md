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
| cidr\_blocks | cidr blocks from which this cluster should accept connections | list | `<list>` | no |
| engine\_version | The engine version for this cluster | string | `4.0.10` | no |
| environment | The environment the redis cluster is running in i.e. dev, prod etc | string | - | yes |
| name | A descriptive name for the redis cluster | string | - | yes |
| node\_type | The type of nodes to use for this cluster | string | - | yes |
| number\_of\_nodes | The number of nodes in this cluster | string | `1` | no |
| paramter\_group\_name | The parameter group name for this cluster | string | `default.redis4.0` | no |
| subnet\_ids | The list of subnet IDs associated to a vpc | list | `<list>` | no |
| tags | A map of tags to add to all resources | map | `<map>` | no |
| transit\_encryption\_enabled | Should transit encryption be enabled for this cluster | string | `false` | no |
| vpc\_id | The VPC ID to create the resources within | string | - | yes |
