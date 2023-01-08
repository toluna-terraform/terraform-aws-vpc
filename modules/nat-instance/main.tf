// Create security groups that allows all traffic from VPC's cidr to NAT-Instance.
resource "aws_security_group" "nat_instance_sg" {
    vpc_id = var.aws_vpc_id
    name   = "${var.env_name}-nat-instance"

    ingress {
        from_port       = 0
        to_port         = 0
        protocol        = "all"
        cidr_blocks     = [var.vpc_cidr]
        prefix_list_ids = []
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "all"
        cidr_blocks     = ["0.0.0.0/0"]
    }
    tags = {
        Name = "sg-nat-instance-${var.env_name}"
    }
}

// Create role.
resource "aws_iam_role" "ssm_agent_role" {
  name               = "iam-role-ssm-agent-${var.env_name}"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": {
      "Effect": "Allow",
      "Principal": {"Service": "ec2.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }
})
}

// Attach role to policy.
resource "aws_iam_role_policy_attachment" "attach_ssm_role" {
  policy_arn = var.ssm_agent_policy
  role       = aws_iam_role.ssm_agent_role.name
}

// Create instance profile.
resource "aws_iam_instance_profile" "nat_instance_profile" {
  name = "iam-profile-nat-instance-${var.env_name}"
  role = aws_iam_role.ssm_agent_role.name
}

resource "aws_network_interface" "network_interface" {
  source_dest_check = false
  subnet_id         = var.public_subnets_ids[0]
  security_groups   = [aws_security_group.nat_instance_sg.id]

  tags = {
    Name = "nat-instance-network-interface-${var.env_name}"
  }
}

// Route private networks through NAT-Instance network interface.
resource "aws_route" "route_to_nat_instace" {
  count = length(var.private_rtb_ids)
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_network_interface.network_interface.id
  route_table_id = var.private_rtb_ids[count.index]
}

resource "tls_private_key" "nat_instance_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "nat_instance_key_pair" {
  key_name   = "ec2-nat-instance-${var.env_name}"
  public_key = tls_private_key.nat_instance_private_key.public_key_openssh
}

resource "aws_ssm_parameter" "nat_instance_ssm" {
  name        = "/infra/ec2-nat-instance-${var.env_name}/key"
  description = "ec2-nat-instance-${var.env_name} ssh key"
  type        = "SecureString"
  value       = tls_private_key.nat_instance_private_key.private_key_pem

  tags = {
  }
}

// Creating NAT Instance.
resource "aws_instance" "nat_instance" {
  // Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs.
  instance_type         = var.nat_instance_type
  key_name              = aws_key_pair.nat_instance_key_pair.key_name
  ami                   = data.aws_ami.amazon_linux.id
  iam_instance_profile  = aws_iam_instance_profile.nat_instance_profile.name
  user_data             = file("${path.module}/nat-instance-setup.sh")
  
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.network_interface.id
  }

  tags = {
    Name = "ec2-nat-instance-${var.env_name}"
  }
}
