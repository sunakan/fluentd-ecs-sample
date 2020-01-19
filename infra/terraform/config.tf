################################################################################
# Terraform自体のバージョン
# terraform-providerのバージョン
# シンボリックリンクとして利用する
# 理由
#   - Terraform用のディレクトリ毎にバージョンを上げるとき、面倒なため
################################################################################
terraform {
  required_version = "0.12.19"
}

provider "null" {
  version = "~> 2.1"
}

provider "aws" {
  version = "2.45.0"
  region  = "ap-northeast-1"
  profile = var.target_aws_account_profile
}

################################################################################
# 共有用リソースのarn等を取得する時利用する
################################################################################
provider "aws" {
  alias   = "shared"
  version = "2.45.0"
  region  = "ap-northeast-1"
  profile = "shared"
}

################################################################################
# 前提：~/.aws/credentialで[AWS_PROFILE]を設定済み
# terraform.tfvarsで以下のようにdefault値を上書きして利用
# target_aws_account_profile = "development"
################################################################################
variable "target_aws_account_profile" {
  description = "Terraform用のIAMuser/IAMroleのプロフィール名"
  type        = string
  default     = "AWS_PROFILE"
}
