# resource "aws_autoscaling_group" "ec2-cluster" {
#   name                 = "${var.ec2_instance_name}_auto_scaling_group"
#   min_size             = var.autoscale_min
#   max_size             = var.autoscale_max
#   desired_capacity     = var.autoscale_desired
#   health_check_type    = "EC2"
#   launch_template { 
#     id = aws_launch_template.ec2.id
#     # id = aws_launch_template.ec2.name
#   }
#   vpc_zone_identifier  = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
#   target_group_arns    = [aws_alb_target_group.default-target-group.arn]

#   tag {
#     key = "Name"
#     value = "Bastion"
#     propagate_at_launch = true
#   }
# }

# resource "aws_autoscaling_group" "bastion-cluster" {
#   name                 = "${var.bastion_instance_name}_auto_scaling_group_bastion"
#   min_size             = var.autoscale_bastion_min
#   max_size             = var.autoscale_bastion_max
#   desired_capacity     = var.autoscale_bastion_desired
#   health_check_type    = "EC2"
#   launch_template { 
#     id = aws_launch_template.bastion.id
#     # id = aws_launch_template.bastion.name
#   }
#   vpc_zone_identifier  = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-1.id]
#   target_group_arns    = [aws_alb_target_group.default-target-group-2.arn]

#   tag {
#     key = "Name"
#     value = "Web Server"
#     propagate_at_launch = true
#   }
# }