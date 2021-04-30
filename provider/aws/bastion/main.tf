resource "aws_key_pair" "terraform-key" {
  key_name   = var.ssh_key_name
  public_key = file("${path.module}/${var.ssh_public_key_path}")
}

resource "aws_security_group" "ssh" {
  name        = "Allow SSH Connections"
  description = "Allow SSH Connections"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips_to_ssh
  }
  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips_to_ssh
  }
  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips_to_ssh
  }  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips_to_ssh
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
            "Name", "SSH Only",
          )
        ) 
  
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "server" {
  count = var.create ? 1 : 0
  instance_type          = var.instance_type
  key_name               = aws_key_pair.terraform-key.key_name
  vpc_security_group_ids = compact(
      list(
        aws_security_group.ssh.id,
        var.allowed_security_group_id == null ? "" : var.allowed_security_group_id
      )
  )
  subnet_id              = var.public_subnets_ids.0
  ami                    = data.aws_ami.amazon-linux-2.id
  tags = merge(
          var.tags_shared,
          map( 
            "Name", "bastion-${var.name}",
          )
        ) 
  volume_tags = "${
      merge(
        var.tags_shared,
        map( 
          "Name", "bastion-${var.name}",
        )
      ) 
  }"
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }
}

resource "aws_eip" "public-server-ip" {
  count = var.create ? 1 : 0
  vpc        = true
  instance   = aws_instance.server.0.id
  tags = merge(
          var.tags_shared,
          map( 
            "Name", "bastion-${var.name}",
          )
        ) 
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }
}
