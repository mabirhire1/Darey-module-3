output "cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.webapp_cluster.id
}

output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.webapp_service.name
}

output "load_balancer_dns" {
  description = "DNS name of the load balancer"
  value       = aws_lb.webapp_alb.dns_name
}

output "load_balancer_url" {
  description = "URL of the load balancer"
  value       = "http://${aws_lb.webapp_alb.dns_name}"
}
