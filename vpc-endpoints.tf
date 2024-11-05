data "aws_subnet" "available_subnets" {
  count = length(module.vpc.intra_subnets)
  id    = module.vpc.intra_subnets[count.index]
}

locals {
  az_list = tolist(toset([for s in data.aws_subnet.available_subnets : s.availability_zone]))

  # az_to_subnet_map    = { for index, s in data.aws_subnet.available_subnets : s.availability_zone => s.id if !contains(local.az_list[index], s.availability_zone) }
  # one_subnet_per_zone = [for az in local.az_list : local.az_to_subnet_map[az]]
  one_subnet_per_zone = [for az in local.az_list : [for s in data.aws_subnet.available_subnets : s.id if s.availability_zone == az][0]]

}


output "one_subnet_per_zone" {
  value = local.one_subnet_per_zone
}

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  #version = "3.18.1"

  vpc_id = module.vpc.vpc_id

  endpoints = {
    s3 = {
      # Gateway endpoint
      service             = "s3"
      service_type        = "Gateway"
      route_table_ids     = module.vpc.intra_route_table_ids # add the id(s) of your route table(s) here
      private_dns_enabled = true                               # optional

    },
    ssm = {
      # interface endpoint
      service             = "ssm"
      security_group_ids  = [aws_security_group.sg-tls.id]
      subnet_ids          = local.one_subnet_per_zone
      private_dns_enabled = true
    },
    ec2messages = {
      # interface endpoint
      service             = "ec2messages"
      security_group_ids  = [aws_security_group.sg-tls.id]
      subnet_ids          = local.one_subnet_per_zone
      private_dns_enabled = true
    },
    ssmmessages = {
      # interface endpoint
      service             = "ssmmessages"
      security_group_ids  = [aws_security_group.sg-tls.id]
      subnet_ids          = local.one_subnet_per_zone
      private_dns_enabled = true
    },
    kms = {
      # interface endpoint
      service             = "kms"
      security_group_ids  = [aws_security_group.sg-tls.id]
      subnet_ids          = local.one_subnet_per_zone
      private_dns_enabled = true
    },
    logs = {
      # interface endpoint
      service             = "logs"
      security_group_ids  = [aws_security_group.sg-tls.id]
      subnet_ids          = local.one_subnet_per_zone
      private_dns_enabled = true
    },
    monitoring = {
      # interface endpoint
      service             = "monitoring"
      security_group_ids  = [aws_security_group.sg-tls.id]
      subnet_ids          = local.one_subnet_per_zone
      private_dns_enabled = true
    },
    ec2 = {
      # interface endpoint
      service             = "ec2"
      security_group_ids  = [aws_security_group.sg-tls.id]
      subnet_ids          = local.one_subnet_per_zone
      private_dns_enabled = true
    },
    sts = {
      # interface endpoint
      service             = "sts"
      security_group_ids  = [aws_security_group.sg-tls.id]
      subnet_ids          = local.one_subnet_per_zone
      private_dns_enabled = true
    }
  }

  #tags = local.tags

  #depends_on = [module.route-53]
  #depends_on = [resource.aws_route53_zone.private_zone]

}

resource "aws_security_group" "sg-tls" {
  name        =  "lum-${var.project_name}-${var.env}-vpce-sg-tls" #local.ssm_sg_name 
  #name        =  "allow_tls"
  description = "Allow TLS inbound traffic for SSM/EC2 endpoints"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block] #local.ingress_cidrs
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  #tags = merge(local.sg_tags, {
  tags = {
    Name = "lum-${var.project_name}-${var.env}-vpce-sg-vpce-tls"
  }
}