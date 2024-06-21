resource "aws_instance" "module-ec2" {
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    security_groups             = [aws_security_group.module-sg.id]
    iam_instance_profile        = var.iam_profile
    key_name = var.ssh-key
    associate_public_ip_address = var.associate_public_ip
    tags = {
        Name    = var.names.ec2
    }
    user_data = var.user_data

  provisioner "local-exec" {
  command = <<EOT
    scp -i /Users/sandesh/Downloads/Key-Sandesh.pem -o StrictHostKeyChecking=no -r ec2-ansible ubuntu@${self.public_ip}:/home/ubuntu/
    ssh -i /Users/sandesh/Downloads/Key-Sandesh.pem -o StrictHostKeyChecking=no ubuntu@${self.public_ip} "ansible-playbook -i /home/ubuntu/ansible/inventory.ini /home/ubuntu/ansible/playbook.yml"
  EOT
}

}

resource "aws_security_group" "module-sg" {
  name        = var.names.sg
  description = "SG for the Public Instance"
  vpc_id      = var.vpc_id
  tags = {
    Name = var.names.sg
  }

  ingress {
    description = "Allow HTTP"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  egress {
    description = "Outbound Rules to Allow All Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
