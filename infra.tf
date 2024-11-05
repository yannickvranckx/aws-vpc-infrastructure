#########
# INFRA #
#########

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws" #https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/examples/complete/main.tf
  #version = "latest"

  name = "lum-${var.project_name}-${var.env}-vpc-${var.region_short}"
  cidr = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  enable_dhcp_options              = true
  dhcp_options_domain_name         = local.dhcp_domain
  #dhcp_options_domain_name_servers = ["127.0.0.1", "10.10.0.2"] #when not configured, the default will be set to "AmazonProvidedDNS"

  azs             = local.azs
  intra_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 3, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 3, k + 4)]


  #Following 2 options are required to avoid the creation of a single routing table per subnet
  enable_nat_gateway = false
  single_nat_gateway = true

  # Naming routing tables
  default_route_table_name = "lum-${var.project_name}-${var.env}-default-route-table-${var.region_short}"
 
  intra_route_table_tags = {
    Name = "lum-${var.project_name}-${var.env}-${var.region_short}-intra_route_table"
  }

  #Enable_transit_gateway_attachment = true
  #transit_gateway_id                = var.transit_gateway_id
  #transit_gateway_routes = [
  #  for subnet in var.subnets : subnet.cidr if subnet.tgw_attachment
  #]
  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true
  flow_log_cloudwatch_log_group_retention_in_days = 30
  
  #Manage the default security group
  manage_default_security_group = true
  default_security_group_egress = []
  default_security_group_ingress = []
  default_security_group_name = " ***DEFAULT - DO NOT USE *** "

  #Manage the default network ACL
  manage_default_network_acl = true
  default_network_acl_name = " *** DEFAULT - DO NOT USE *** "

}
