output "alb_dns" {
  value = aws_lb.benjaminfiche.dns_name
}
output "alb_zone" {
  value = aws_lb.benjaminfiche.zone_id
}