export TARGET_AWS_ACCOUNT_PROFILE=development

init:
	terraform init
plan:
	terraform plan -var target_aws_account_profile=${TARGET_AWS_ACCOUNT_PROFILE}
apply:
	terraform apply -var target_aws_account_profile=${TARGET_AWS_ACCOUNT_PROFILE}
destroy:
	terraform destroy -var target_aws_account_profile=${TARGET_AWS_ACCOUNT_PROFILE}
