locals {
  region = "eu-west-3"
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
  dhcp_domain = "rsrc.int"
}