#
# NAT Security Group
#
resource "aws_security_group" "nat" {
  name = "nat"
  description = "Allow nat traffic"
  vpc_id = aws_vpc.main.id

  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = [var.vpc_cidr]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags,
    {
      Name = "${var.Name_tag_prefix}-nat-sg"
    }
  )
}

#
# NAT Module
#
resource "aws_instance" "nat" {
  ami                    = var.nat_ami
  instance_type          = var.nat_instance_type
  source_dest_check      = false
  key_name               = var.nat_private_key_name
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.nat.id]
  tags = merge(var.tags,
    {
      Name = "${var.Name_tag_prefix}-nat"
    }
  )
}

