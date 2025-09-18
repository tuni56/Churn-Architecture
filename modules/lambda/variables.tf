variable "function_name" { type = string }
variable "handler" { type = string }
variable "runtime" { type = string }
variable "code_path" { type = string }
variable "role_arn" { type = string }
variable "triggers" { type = list(string), default = null }
