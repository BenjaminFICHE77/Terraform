# data "aws_ami" "ami" {
#   most_recent = true
#   filter {
#     name = "name"
#     values = [
#       "amzn2-ami-hvm-*",
#     ]
#   }

#   owners = [
#     "amazon",
#   ]
# }

# resource "aws_launch_template" "bastion" {
#   image_id                         = data.aws_ami.ami.id
#   instance_type               = "${var.instance_type}"
#   key_name                    = aws_key_pair.benjaminfiche.key_name
#   security_group_names            = [aws_security_group.ec2.id]
# }

# resource "aws_launch_template" "ec2" {
#   name                        = "${var.ec2_instance_name}-instances-lc"
#   image_id                    = data.aws_ami.ami.id
#   instance_type               = "${var.instance_type}"
#   key_name                    = aws_key_pair.benjaminfiche.key_name
#   user_data                   = base64encode(data.template_file.db_cred.rendered)
#   # security_group_names             = [aws_security_group.ec2.id]
#   network_interfaces {
#     security_groups = [ aws_security_group.ec2.id ]
#   }
# }

# data "template_file" "db_cred" {
#   template = "${file("install_wordpress.sh")}"
#   vars = {
#     db_username = "username"
#     db_user_password = "password"
#     db_name = "wordpressdb"
#     db_RDS = aws_db_instance.wordpress_db.address
#     dns_host = aws_lb.benjaminfiche.dns_name
#   }
# }