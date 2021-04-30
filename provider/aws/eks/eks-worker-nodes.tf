#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EC2 Security Group to allow networking traffic
#  * Data source to fetch latest EKS worker AMI
#  * AutoScaling Launch Configuration to configure worker instances
#  * AutoScaling Group to launch worker instances
#

data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.eks-cluster.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We utilize a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html

//https://stackoverflow.com/questions/51432341/eks-node-labels
locals {
  ava-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks-cluster.endpoint}' --kubelet-extra-args --node-labels=node-type=__{node-label}__ --b64-cluster-ca '${aws_eks_cluster.eks-cluster.certificate_authority.0.data}' '${var.eks_cluster_identifier}'
USERDATA
}

resource "aws_launch_template" "eks-worker-node-template" {
  count = length(var.eks_nodes)
  name_prefix   = "eks-${var.eks_cluster_identifier}-${var.eks_nodes[count.index]["label"]}"
  image_id      = data.aws_ami.eks-worker.id
  instance_type = var.eks_nodes[count.index]["instanceType"]
  user_data     = base64encode(replace(local.ava-node-userdata, "__{node-label}__", var.eks_nodes[count.index]["label"]))
  instance_initiated_shutdown_behavior = "terminate"

  iam_instance_profile {
    name = aws_iam_instance_profile.eks-worker-node.name
  }
  
  network_interfaces {
    associate_public_ip_address = true
    security_groups = concat([aws_security_group.eks-worker-node.id,aws_security_group.eks-worker-node-client.id], var.eks_security_groups_ids)
  }

  monitoring {
    enabled = true
  }

  tags = var.tags_shared

  tag_specifications {
    resource_type = "instance"
    tags = var.tags_shared
  }

  tag_specifications {
    resource_type = "volume"
    tags = var.tags_shared
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [
      image_id, tags["data-criacao"], 
      tag_specifications.0.tags["data-criacao"], 
      tag_specifications.1.tags["data-criacao"]
    ]
  }
}

resource "aws_autoscaling_group" "eks-worker-node-template-autoscaling-group" {
  count = length(var.eks_nodes)
  desired_capacity     = var.eks_nodes[count.index]["desiredSize"]
  max_size             = var.eks_nodes[count.index]["maxSize"]
  min_size             = var.eks_nodes[count.index]["minSize"]
  name                 = "eks-${var.eks_cluster_identifier}-${var.eks_nodes[count.index]["label"]}-template"
  vpc_zone_identifier  = length(var.private_subnets_ids) > var.eks_nodes[count.index]["maxSize"] ? (
                            slice(var.private_subnets_ids, 0, var.eks_nodes[count.index]["maxSize"])) : (
                            var.private_subnets_ids
                          )
  termination_policies = ["NewestInstance"]

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.eks-worker-node-template[count.index].id
        version = aws_launch_template.eks-worker-node-template[count.index].latest_version
      }
    }

    instances_distribution {
      on_demand_base_capacity = var.eks_nodes[count.index]["instanceOndemandBaseSize"]
      on_demand_percentage_above_base_capacity = var.eks_nodes[count.index]["instanceOnDemandPercentagem"]
    }
  }

  dynamic "tag" {
    for_each = merge(var.tags_shared, local.kubernetes_tags, var.eks_nodes[count.index]["enableAutoScale"] ? local.kubernetes_autoscalling_tags : {} )
    content {
      key = tag.key
      value = tag.value
      propagate_at_launch = true
    }
  }

  tag {
    key                 = "Name"
    value               = "eks-${var.eks_cluster_identifier}-${var.eks_nodes[count.index]["label"]}"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes        = [
      desired_capacity, min_size, //tag,
      mixed_instances_policy.0.instances_distribution.0.on_demand_base_capacity  
    ] 
  }
}