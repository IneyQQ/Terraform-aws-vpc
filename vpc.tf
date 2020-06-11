#
# VPC
#
resource aws_vpc main {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = merge(var.tags,
    {
      Name = "${var.Name_tag_prefix}-vpc"
    }
  )
}

#
# Interget Gateway
#
resource aws_internet_gateway main {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags,
    {
      Name = "${var.Name_tag_prefix}-igw"
    }
  )
}

#
# Subnets BEGIN
#
resource aws_subnet public {
  count = length(var.az_list)
  availability_zone = var.az_list[count.index]
  vpc_id = aws_vpc.main.id
  map_public_ip_on_launch = true
  cidr_block = var.vpc_public_subnet_cidrs[count.index]
  tags = merge(var.tags,
    {
      Name = "${var.Name_tag_prefix}-subnet-public-${count.index}"
    }
  )
}

resource aws_subnet private {
  count = length(var.az_list)
  availability_zone = var.az_list[count.index]
  vpc_id = aws_vpc.main.id
  map_public_ip_on_launch = false
  cidr_block = var.vpc_private_subnet_cidrs[count.index]
  tags = merge(var.tags,
    {
      Name = "${var.Name_tag_prefix}-subnet-private-${count.index}"
    }
  )
}

resource aws_subnet nointernet {
  count = length(var.az_list)
  availability_zone = var.az_list[count.index]
  vpc_id = aws_vpc.main.id
  map_public_ip_on_launch = false
  cidr_block = var.vpc_nointernet_subnet_cidrs[count.index]
  tags = merge(var.tags,
    {
      Name = "${var.Name_tag_prefix}-subnet-nointernet-${count.index}"
    }
  )
}
#
# Subnets END
#

#
# Route tables BEGIN
#
resource aws_route_table public {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.tags,
    {
      Name = "${var.Name_tag_prefix}-RT-public"
    }
  )
}
resource aws_route_table private {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    instance_id = aws_instance.nat.id
  }

  tags = merge(var.tags,
    {
      Name = "${var.Name_tag_prefix}-RT-private"
    }
  )
}
#
# Route tables END
#

#
# RT Associations BEGIN
#
resource aws_route_table_association public {
  count = length(var.az_list)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
resource aws_route_table_association private {
  count = length(var.az_list)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
#
# RT Associations END
#

