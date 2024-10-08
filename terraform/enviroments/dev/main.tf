terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "no-commit-notify-terraform-state"
    key     = "state/dev/terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id                = data.aws_caller_identity.current.account_id
  region                    = data.aws_region.current.name
  bucket_name               = "${var.project_prefix}-${local.account_id}"
  function_name             = var.project_prefix
  lambda_iam_role_name      = "${var.project_prefix}-iam-lambda-role"
  lambda_iam_policy_name    = "${var.project_prefix}-iam-lambda-policy"
  eventbridge_iam_role_name = "${var.project_prefix}-iam-eventbridge-role"
  repository_name           = var.project_prefix
  image_uri                 = "${local.account_id}.dkr.ecr.${local.region}.amazonaws.com/${local.repository_name}"
  schedule_rule             = "${var.project_prefix}-schedule-rule"
  enviroment_variables = {
    ENV                          = "${var.enviroment}"
    GITHUB_USER                  = "${var.user_github}"
    GITHUB_TOKEN_PARAM_NAME      = "/${var.project_prefix}/github_token"
    LINE_NOTIFY_TOKEN_PARAM_NAME = "/${var.project_prefix}/line_notify_token"
  }
}
