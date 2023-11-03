output "load_balancer_url" {
  value = aws_lb.web.dns_name
}