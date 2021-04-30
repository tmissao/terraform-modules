data "aws_subnet" "selected" {
  id = element(var.public_subnets_ids, 0)
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04*"]
  }

  filter {
    name   = "hypervisor"
    values = ["xen"]
  }
}

resource "aws_key_pair" "ssh-key" {
  count = var.ssh_create_key ? 1 : 0
  key_name   = var.ssh_key_name
  public_key = var.ssh_public_key != null ? var.ssh_public_key : file("${path.module}/keys/key.pem")
  tags = var.tags_shared
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }
}

resource "aws_security_group" "rancher" {
  name        = "Rancher Server Security Group"
  description = "Allow Connection with Rancher Server"
  vpc_id      = data.aws_subnet.selected.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_allowed_ips
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
          var.tags_shared,
          map( 
            "Name", "Rancher Security Group",
          )
        ) 

  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }
}

data "template_file" "init" {
    template = file("${path.module}/scripts/init.cfg")
}

data "template_file" "shell-script" {
    template = file("${path.module}/scripts/setup.sh")
    vars = {
        DEVICE = var.rancher_ebs_device_name
        MOUNT_POINT = var.rancher_ebs_mount_point
        DOMAIN = var.rancher_hostname_domain
    }
}

data "template_cloudinit_config" "config" {
    gzip = true
    base64_encode = true

    part {
        filename = "init.cfg"
        content_type = "text/cloud-config"
        content = data.template_file.init.rendered
    }

    part {
        content_type = "text/x-shellscript"
        content = data.template_file.shell-script.rendered
    }
}


resource "aws_instance" "server" {
  instance_type          = var.instance_size
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.rancher.id]
  subnet_id              = element(var.public_subnets_ids, 0)
  ami                    = data.aws_ami.ubuntu.id
  user_data_base64       = data.template_cloudinit_config.config.rendered
  tags = merge(
          var.tags_shared,
          map( 
            "Name", "rancher-server",
          )
        ) 
  volume_tags = merge(
                  var.tags_shared,
                  map( 
                    "Name", "rancher-server",
                  )
                ) 
  
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }
}

resource "aws_ebs_volume" "rancher-volume" {
  availability_zone = data.aws_subnet.selected.availability_zone
  size              = var.rancher_ebs_size_gb
  encrypted         = "true"
  type              = "gp2"

  tags = merge(
          var.tags_shared,
          map( 
            "Name", "rancher-server",
          )
        ) 
}

resource "aws_volume_attachment" "rancher-volume-attachment" {
  device_name = var.rancher_ebs_device_name
  volume_id   = aws_ebs_volume.rancher-volume.id
  instance_id = aws_instance.server.id
}

resource "aws_eip" "rancher_ip" {
  vpc = true
  instance = aws_instance.server.id
  tags = merge(
          var.tags_shared,
          map( 
            "Name", "rancher-server",
          )
        ) 
}



