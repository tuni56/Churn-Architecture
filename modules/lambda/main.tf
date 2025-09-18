resource "aws_lambda_function" "this" {
  function_name = var.function_name
  handler       = var.handler
  runtime       = var.runtime
  role          = var.role_arn
  filename      = "${var.code_path}.zip"

  depends_on = var.triggers != null ? var.triggers : []
}

output "lambda_arn" {
  value = aws_lambda_function.this.arn
}
