provider "aws" {
  region = "us-east-1"  # Substitua pela sua região
}

# Compacta o código da Lambda
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../hello-world"   # Caminho para o diretório do código
  output_path = "${path.module}/function.zip"
}

# Recurso Lambda
resource "aws_lambda_function" "hello_world" {
  function_name     = "HelloWorldFunction"
  handler           = "app.handler"
  runtime           = "nodejs20.x"
  filename          = data.archive_file.lambda_zip.output_path  # Aponta para o arquivo zip gerado
  source_code_hash  = data.archive_file.lambda_zip.output_base64sha256  # Usa o hash gerado pelo recurso

  role = "arn:aws:iam::767397741290:user/teste"
}



# Anexa a política de execução básica da Lambda
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
