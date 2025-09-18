resource "aws_sfn_state_machine" "this" {
  name     = var.state_machine_name
  role_arn = var.role_arn

  definition = <<EOF
{
  "Comment": "Churn pipeline state machine",
  "StartAt": "Ingest",
  "States": {
    "Ingest": {
      "Type": "Task",
      "Resource": "${var.lambda_ingest_arn}",
      "Next": "TrainModel"
    },
    "TrainModel": {
      "Type": "Task",
      "Resource": "${var.sagemaker_training_arn}",
      "Next": "Scoring"
    },
    "Scoring": {
      "Type": "Task",
      "Resource": "${var.lambda_scoring_arn}",
      "End": true
    }
  }
}
EOF
}

output "state_machine_arn" {
  value = aws_sfn_state_machine.this.arn
}
