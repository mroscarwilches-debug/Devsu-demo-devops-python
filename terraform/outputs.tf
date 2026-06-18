# After running "terraform apply", these values are printed on screen.

output "cluster_name" {
  description = "The name of your Kubernetes cluster"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "The URL to talk to the Kubernetes API"
  value       = aws_eks_cluster.main.endpoint
}

output "ecr_repository_url" {
  description = "Push your Docker image here (like Docker Hub, but in AWS)"
  value       = aws_ecr_repository.main.repository_url
}

output "region" {
  description = "The AWS region where everything was created"
  value       = var.aws_region
}

output "connect_command" {
  description = "Copy and run this to connect kubectl to your new cluster"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.main.name}"
}
