# resource "aws_key_pair" "benjaminfiche" {
#   key_name   = "${var.ec2_instance_name}_key_pair"
#   public_key = file(var.ssh_pubkey_file)
# }