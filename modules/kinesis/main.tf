resource "aws_kinesis_stream" "this" {
  name        = var.stream_name
  shard_count = var.shard_count
}

output "stream_arn" {
  value = aws_kinesis_stream.this.arn
}
