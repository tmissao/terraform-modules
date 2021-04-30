resource "aws_elb" "loadbalancer" {
  name = var.name
  name_prefix = var.name_prefix
  security_groups = var.security_groups_ids
  subnets = var.subnets_ids
  instances = var.instances_ids
  internal = var.internal 
  cross_zone_load_balancing = var.cross_zone_load_balancing
  idle_timeout = var.idle_timeout
  connection_draining = var.connection_draining
  connection_draining_timeout = var.connection_draining_timeout
  
  dynamic "listener" {
    for_each = var.listeners
    content {
      instance_port = listener.value["instance_port"]
      instance_protocol  = listener.value["instance_protocol"]
      lb_port = listener.value["lb_port"]
      lb_protocol = listener.value["lb_protocol"]
      ssl_certificate_id  = listener.value["ssl_certificate_id"]
    }
  }

  dynamic "health_check" {
    for_each = var.health_check
    content {
      healthy_threshold = health_check.value["healthy_threshold"]
      unhealthy_threshold  = health_check.value["unhealthy_threshold"]
      target = health_check.value["target"]
      interval = health_check.value["interval"]
      timeout  = health_check.value["timeout"]
    }
  }

  tags = var.tags_shared
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }
}
