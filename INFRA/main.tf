provider "aws" {
  region = var.region
}

module "kinesis" {
  source      = "./modules/kinesis"
  stream_name = "events-stream"
  shard_count = 2
}

module "s3_raw" {
  source      = "./modules/s3"
  bucket_name = "company-churn-raw"
}

module "s3_models" {
  source      = "./modules/s3"
  bucket_name = "company-churn-models"
}

module "dynamodb" {
  source      = "./modules/dynamodb"
  table_name  = "user-features"
}

module "lambda_ingest" {
  source       = "./modules/lambda"
  function_name = "ingest-lambda"
  handler      = "ingest_lambda.handler"
  runtime      = "python3.10"
  code_path    = "../services/ingest/"
  role_arn     = module.lambda_roles.lambda_role_arn
  triggers     = [module.kinesis.stream_arn]
}

module "lambda_scoring" {
  source       = "./modules/lambda"
  function_name = "scoring-lambda"
  handler      = "scoring_lambda.handler"
  runtime      = "python3.10"
  code_path    = "../services/scoring/"
  role_arn     = module.lambda_roles.lambda_role_arn
}

module "sagemaker" {
  source     = "./modules/sagemaker"
  model_name = "churn-xgb-model"
  role_arn   = module.lambda_roles.sagemaker_role_arn
  s3_output  = module.s3_models.bucket_arn
}

module "stepfunctions" {
  source               = "./modules/stepfunctions"
  state_machine_name   = "churn-pipeline-sm"
  lambda_ingest_arn    = module.lambda_ingest.lambda_arn
  lambda_scoring_arn   = module.lambda_scoring.lambda_arn
  sagemaker_training_arn = module.sagemaker.training_job_arn
}

module "api_gateway" {
  source       = "./modules/api_gateway"
  api_name     = "churn-api"
  lambda_arn   = module.lambda_scoring.lambda_arn
}

module "sns" {
  source      = "./modules/sns"
  topic_name  = "churn-alerts"
}
