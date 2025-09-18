resource "aws_sagemaker_model" "this" {
  name          = var.model_name
  execution_role_arn = var.role_arn
  primary_container {
    image = "246618743249.dkr.ecr.us-east-1.amazonaws.com/xgboost:latest"
    model_data_url = "${var.s3_output}/model.tar.gz"
  }
}

output "model_arn" { value = aws_sagemaker_model.this.arn }
