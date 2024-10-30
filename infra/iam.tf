data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "create_logs_cloudwatch" {
  statement {
    sid       = "AllowCreatingLogGroups"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]
    actions   = ["logs:CreateLogGroup"]
  }

  statement {
    sid       = "AllowWritingLogs"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:log-group:/aws/lambda/*:*"]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }

  statement {
    sid       = "AllowSecretsManagerReadWrite"
    effect    = "Allow"
    actions   = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:PutSecretValue",
      "secretsmanager:UpdateSecret",
      "secretsmanager:CreateSecret",
      "secretsmanager:DeleteSecret"
    ]
    resources = ["arn:aws:secretsmanager:*:*:secret:*"]
  }
}

resource "aws_iam_role" "push_notification_lambda" {
  name = "push-notification-role3"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
  tags = local.common_tags
}

resource "aws_iam_policy" "create_logs_cloudwatch" {
  name   = "create-cw-logs-policy"
  policy = data.aws_iam_policy_document.create_logs_cloudwatch.json
}



resource "aws_iam_role_policy_attachment" "push_notification_cloudwatch" {
  policy_arn = aws_iam_policy.create_logs_cloudwatch.arn
  role       = aws_iam_role.push_notification_lambda.name
}