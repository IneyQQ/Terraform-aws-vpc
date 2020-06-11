#
# Tags
#
variable tags {
  type = map
  default = {}
  description = "A map of tags to add to all resources"
}
variable Name_tag_prefix {
  description = "Prefix for tag 'Name' and some named resources"
}

#
# VPC vars
#
variable vpc_cidr {}
variable az_list {
  type = list(string)
}
variable vpc_public_subnet_cidrs {
  type = list(string)
}
variable vpc_private_subnet_cidrs {
  type = list(string)
}
variable vpc_nointernet_subnet_cidrs {
  type = list(string)
}

#
# NAT instance vars
#
variable nat_ami {
  default = "ami-00a9d4a05375b2763"
}
variable nat_instance_type {
  default = "t2.nano"
}
variable nat_private_key_name {
  description = "Private key name"
  default     = ""
}

