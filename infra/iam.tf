module "dev_app_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.3.3"

  name                          = var.project_name
  force_destroy                 = true
  create_iam_user_login_profile = false
}

data "aws_iam_policy_document" "dev_app_user_policy" {
  statement {
    sid    = "AppUserPermissions"
    effect = "Allow"

    actions = [
      "ecr:*",
      "ecs:*",
      "s3:*",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "dev_app_user" {
  name        = "dev-app-user-policy"
  description = "Policy that allows service access"
  policy      = data.aws_iam_policy_document.dev_app_user_policy.json
}

resource "aws_iam_user_policy_attachment" "dev_app_user" {
  user       = module.dev_app_user.iam_user_name
  policy_arn = aws_iam_policy.dev_app_user.arn
}

