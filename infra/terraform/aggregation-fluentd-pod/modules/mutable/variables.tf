variable "environment" {
  description = "環境名：候補はsandbox/development/staging/production"
  type        = string
  default     = "INCORRECT"
}

variable "vpc_id" {
  description = "ターゲットグループが属するvpc_id"
  type        = string
  default     = "VPC_ID"
}

variable "subnet_ids" {
  description = "ECSサービスで利用するサブネットのID群"
  type        = set(string)
  default     = []
}

variable "target_group_arn" {
  description = "ECSで利用するターゲットグループのARN"
  type        = string
  default     = "TARGET_GROUP_ARN"
}

variable "aggregation_fluentd_container_repository" {
  description = "集積用のfluendのDockerのリポジトリ"
  type        = string
  default     = "FLUENTD_REPOSITORY"
}

variable "aggregation_s3_bucket_name" {
  description = "集積用のS3バケット名"
  type        = string
  default     = "S3_BUCKET_NAME"
}
