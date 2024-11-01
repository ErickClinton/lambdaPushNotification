
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file  = "${path.module}/../push-notification/app.mjs"
  output_path = "${path.module}/function.zip"
}

# Recurso Lambda
resource "aws_lambda_function" "pushNotification" {
  function_name     = "pushNotification"
  handler           = "app.handler"
  runtime           = "nodejs20.x"
  filename          = data.archive_file.lambda_zip.output_path
  source_code_hash  = data.archive_file.lambda_zip.output_base64sha256

  role = aws_iam_role.push_notification_lambda.arn

  layers = [aws_lambda_layer_version.got.arn]

  tags = local.common_tags
}




