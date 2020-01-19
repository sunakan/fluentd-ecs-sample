################################################################################
# VPCのidやそれのサブネットをfilterだけでとってくる
# 存在することが前提となる
################################################################################
data "aws_vpc" "suna_vpc" {
  filter {
    name   = "tag:Name"
    values = ["suna-vpc"]
  }
}
data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.suna_vpc.id
  filter {
    name = "tag:Name"
    values = [
      "suna-vpc-private-ap-northeast-1a",
      "suna-vpc-private-ap-northeast-1c",
      "suna-vpc-private-ap-northeast-1d",
    ]
  }
}

################################################################################
# Main
################################################################################
module "immutable" {
  source         = "./immutable-module/"
  environment    = "development"
  nlb_subnet_ids = data.aws_subnet_ids.private.ids
  vpc_id         = data.aws_vpc.suna_vpc.id
}
