# resource "aws_acm_certificate" "my-certificate" {
#   domain_name       = "example.com"
#   validation_method = "DNS"

#   tags = {
#     Name = "benjaminfiche-certificate"
#   }
# }

# resource "aws_lb_listener_certificate" "listener_certificate" {
#   listener_arn = aws_alb_listener.ec2-alb-http-listener.arn
#   certificate_arn = aws_acm_certificate.my-certificate.arn
# }

resource "aws_acm_certificate" "certificat" {
  domain_name       = "www.benjaminfiche-fastapi.fr"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}