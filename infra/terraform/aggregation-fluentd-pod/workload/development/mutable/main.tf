################################################################################
# VPCのidや共有用のDockerImageリポジトリをoutputsを使わずとってくる
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
data "aws_lb_target_group" "service_tg" {
  name = "suna-aggregation-fluentd-dev-tg"
}
data "aws_s3_bucket" "log_aggregation_s3_bucket" {
  bucket = "suna-suna-aggregation-fluentd-dev"
}
data "aws_ecr_repository" "aggregation_fluentd" {
  provider = aws.shared
  name     = "sunatra-aggregation-fluentd"
}

################################################################################
# Main
################################################################################
module "mutable" {
  source                                   = "./mutable-module/"
  environment                              = "development"
  vpc_id                                   = data.aws_vpc.suna_vpc.id
  subnet_ids                               = data.aws_subnet_ids.private.ids
  aggregation_fluentd_container_repository = data.aws_ecr_repository.aggregation_fluentd.repository_url
  target_group_arn                         = data.aws_lb_target_group.service_tg.arn
  aggregation_s3_bucket_name               = data.aws_s3_bucket.log_aggregation_s3_bucket.bucket
}
