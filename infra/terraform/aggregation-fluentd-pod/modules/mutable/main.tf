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

  # billingは昔からあるTag
  common_tags = {
    Team        = "suna"
    billing     = "sunatra"
    Project     = "sunatra-pod"
    Repository  = "sunakan/fluentd-ecs-sample"
    Environment = local.env_full
  }

  service_prefix        = "suna"
  service_name_with_env = "suna-aggregation-fluentd-${local.env_short}"
  awslog_group          = "/ecs/${local.service_name_with_env}"
}

################################################################################
# ロギング用CloudWatchのグループを作成
################################################################################
resource "aws_cloudwatch_log_group" "this" {
  name              = local.awslog_group
  retention_in_days = 1
}

################################################################################
# ECSクラスタ                           リスナー---NLB
#    \_ECSサービス---ターゲットグループ_/
#         \_タスク定義(1コンテナ定義を1タスクとした時の必要なマシンリソース等)
#              \_コンテナ定義(コンテナの組み合わせ)
################################################################################
resource "aws_ecs_cluster" "this" {
  name = local.service_name_with_env
  tags = local.common_tags
}

################################################################################
# コンテナ定義モジュール
################################################################################
module "fluentd_container_definition" {
  source          = "cloudposse/ecs-container-definition/aws"
  version         = "0.23.0"
  #container_image = "${var.aggregation_fluentd_container_repository}:${local.env_full}"
  container_image = "fluentd:v1.8-1"
  container_name  = "aggregation-fluentd"
  environment = [
    {
      name  = "ENV"
      value = local.env_full
    },
    {
      name  = "FLUENTD_S3_BUCKET"
      value = var.aggregation_s3_bucket_name
    },
  ]
  log_configuration = {
    logDriver = "awslogs",
    options = {
      awslogs-group         = local.awslog_group,
      awslogs-region        = "ap-northeast-1",
      awslogs-stream-prefix = "ecs",
    },
    secretOptions = [],
  }
  port_mappings = [
    {
      hostPort      = 24224,
      containerPort = 24224,
      protocol      = "tcp",
    },
  ]
}
################################################################################
# タスク定義（サービスで利用される）
# - タスクで実行するコンテナ定義は別ファイルで定義
################################################################################
resource "aws_ecs_task_definition" "this" {
  family                   = local.service_name_with_env
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = "[${module.fluentd_container_definition.json_map}]"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  tags                     = local.common_tags
}

################################################################################
# ECSタスク実行用のポリシーを持ったIAMロールの作成
################################################################################
data "aws_iam_policy" "ecs_task_execution_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
data "aws_iam_policy_document" "ecs_task_execution_principal" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
data "aws_iam_policy_document" "ecs_task_execution_identity" {
  source_json = data.aws_iam_policy.ecs_task_execution_role_policy.policy
  statement {
    effect    = "Allow"
    actions   = ["ssm:GetParameters", "kms:Decrypt"]
    resources = ["*"]
  }
}
resource "aws_iam_policy" "ecs_task_execution_identity" {
  name   = "${local.service_name_with_env}-ecs-task-execution-identity"
  policy = data.aws_iam_policy_document.ecs_task_execution_identity.json
}
resource "aws_iam_role" "ecs_task_execution" {
  name               = "${local.service_name_with_env}-ecs-task-execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_principal.json
  tags               = local.common_tags
}
resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.ecs_task_execution_identity.arn
}

################################################################################
# ECSサービス
#   - 定義したタスク定義とECSクラスタとロードバランサをつなげる
#   - 起動するタスクの数を選択
#   - 何らかの理由でタスクが終了しても自動的に新しいタスクを起動してくれる
################################################################################
resource "aws_security_group" "ecs_service_sg" {
  name        = "${local.service_name_with_env} ecs service sg"
  description = "Using ECS service"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 24224
    to_port     = 24224
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    local.common_tags,
    {
      Name = "${local.service_name_with_env}-sg for ecs serevice",
    }
  )
}
resource "aws_ecs_service" "this" {
  name             = local.service_name_with_env
  cluster          = aws_ecs_cluster.this.id
  task_definition  = aws_ecs_task_definition.this.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "1.3.0"
  health_check_grace_period_seconds = 60
  network_configuration {
    assign_public_ip = false
    security_groups = [
      aws_security_group.ecs_service_sg.id,
    ]
    subnets = var.subnet_ids
  }
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "aggregation-fluentd"
    container_port   = 24224
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}
