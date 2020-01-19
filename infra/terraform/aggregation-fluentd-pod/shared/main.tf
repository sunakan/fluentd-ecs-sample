################################################################################
# ECR
################################################################################
resource "aws_ecr_repository" "aggregation_fluentd" {
  name                 = "sunatra-aggregation-fluentd"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}
