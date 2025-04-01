
resource "aws_elasticache_subnet_group" "example" {
  name       = "example-subnet-group"
  subnet_ids = [var.public_subnet_1_id, var.public_subnet_2_id]

  tags = {
    Name = "ElastiCacheSubnetGroup"
  }
}

resource "aws_elasticache_cluster" "memcached" {
  cluster_id           = "memcached-cluster"
  engine               = "memcached"
  node_type            = "cache.t3.micro"  
  num_cache_nodes      = 1                 
  parameter_group_name = "default.memcached1.6"  
  port                 = 11211
  subnet_group_name    = aws_elasticache_subnet_group.example.name
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id       = "redis-replication-group"
  replication_group_description = "Redis cluster for caching"
  engine                     = "redis"
  node_type                  = "cache.t3.micro"  
  number_cache_clusters      = 1  # Single-node Redis
  parameter_group_name       = "default.redis7"  
  port                       = 6379  
  subnet_group_name          = aws_elasticache_subnet_group.example.name
  automatic_failover_enabled = false  

  tags = {
    Name = "RedisReplicationGroup"
  }
}
