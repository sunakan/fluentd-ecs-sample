export TARGET_AWS_ACCOUNT_PROFILE=shared

init:
	terraform init
fmt:
	terraform fmt --recursive
plan:
	terraform plan -var target_aws_account_profile=${TARGET_AWS_ACCOUNT_PROFILE}
apply:
	terraform apply -var target_aws_account_profile=${TARGET_AWS_ACCOUNT_PROFILE}
destroy:
	terraform destroy -var target_aws_account_profile=${TARGET_AWS_ACCOUNT_PROFILE}
