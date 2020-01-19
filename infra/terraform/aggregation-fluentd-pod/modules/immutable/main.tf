################################################################################
# envはvariableで受け取っているが、短縮形もあり得るため、mapを利用する
#   - 更にmapのkeyでバリデーションみたいな使い方が可能（enumのような挙動が可能）
################################################################################
locals {
  env_full = var.environment
  env_short = map(
    "sandbox", "sndbox",
    "development", "dev",
    "staging", "stg",
    "production", "prd",
  )[local.env_full]

  common_tags = {
    Team        = "suna"
    billing     = "sunatra"
    Project     = "sunatra-aggregation-fluentd"
    Repository  = "sunakan/fluentd-ecs-sample"
    Environment = local.env_full
  }

  service_prefix        = "suna"
  service_name_with_env = "suna-aggregation-fluentd-${local.env_short}"
}

################################################################################
# Logを集約するためのS3バケット
################################################################################
resource "aws_s3_bucket" "this" {
  bucket = "${local.service_prefix}-${local.service_name_with_env}"
  acl    = "private"
  tags   = local.common_tags
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

################################################################################
# NLB（置くだけで1h毎に料金発生するため注意）
################################################################################
resource "aws_lb" "this" {
  name                       = "${local.service_name_with_env}-nlb"
  internal                   = true
  load_balancer_type         = "network"
  subnets                    = var.nlb_subnet_ids
  enable_deletion_protection = false
  tags                       = local.common_tags
}

################################################################################
# ターゲットグループ
################################################################################
resource "aws_lb_target_group" "this" {
  name                 = "${local.service_name_with_env}-tg"
  port                 = 24224
  protocol             = "TCP"
  vpc_id               = var.vpc_id
  deregistration_delay = 180
  health_check {
    protocol            = "TCP"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 30
  }
  tags = local.common_tags
}

################################################################################
# Listener
#   - L4で飛ばしたいためprotocolはtcp
#   - Fluentdのデフォルトポートは24224
#   - デフォルトアクションでターゲットグループに飛ばす
################################################################################
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 24224
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
