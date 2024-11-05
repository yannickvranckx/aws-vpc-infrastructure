##################
# TGW ATTACHMENT #
##################
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment" {
  subnet_ids = module.vpc.intra_subnets

  transit_gateway_id = var.tgw_id
  vpc_id             = module.vpc.vpc_id
  security_group_referencing_support = "enable"

  tags = {
    "Name" = "tgw-attachment-${var.project_name}-${var.env}-${var.region_short}"  #-${var.account_name}"
  }
}