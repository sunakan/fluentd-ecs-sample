variable "environment" {
  description = "環境名：候補はsandbox/development/staging/production"
  type        = string
  default     = "INCORRECT"
}

variable "nlb_subnet_ids" {
  description = "NetworkLoadBalancerが対応するサブネット群のids"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "ターゲットグループが属するvpc_id"
  type        = string
  default     = "VPC_ID"
}
