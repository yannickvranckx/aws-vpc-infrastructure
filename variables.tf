# Variable file
# --------------

# Project vars
# ---------
variable "project_name" {
  description = "Name of project"
  type        = string
}
variable "env" {
  description = "Name of environment"
  type        = string
}
variable "region_short" {
  description = "Name of region truncated"
  type        = string
}
variable "vpc_cidr" {
    description = "VPC CIDR"
    type = string
}
variable "tgw_id" {
  description = "TGW ID"
  type = string
}