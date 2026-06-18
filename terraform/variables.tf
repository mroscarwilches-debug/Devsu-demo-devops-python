# These are the knobs you can turn to customize the infrastructure.

variable "aws_region" {
  description = "Which AWS region to deploy to (pick one close to your users)"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "A name to identify all resources — shows up in tags and resource names"
  type        = string
  default     = "demo-devops"
}

variable "node_instance_type" {
  description = "The size of the servers that run our app (t3.small is cheap and enough for this)"
  type        = string
  default     = "t3.small"
}

variable "node_count" {
  description = "How many servers we want running in the cluster"
  type        = number
  default     = 2
}
