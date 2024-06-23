module "ec2" {
  source              = "./modules/ec2"
  ami                 = "ami-0e001c9271cf7f3b9" #Ubuntu 22.04
  instance_type       = "t2.micro"
  subnet_id           = "subnet-0639d260294d92a5d"
  associate_public_ip = true
  iam_profile         = data.aws_iam_instance_profile.iam.name
  ssh-key             = "Key-Sandesh"
  security_group      = aws_security_group.module-sg.id
}

data "aws_vpc" "vpc" {
  id = "vpc-03d964f7cd3fa2c74"
}

data "aws_iam_instance_profile" "iam" {
  name = "SSM-Sandesh"
}

resource "aws_security_group" "module-sg" {
  name        = "SG-module-sandesh"
  description = "SG for the Public Instance"
  vpc_id      = data.aws_vpc.vpc.id
  tags = {
    Name = "SG-module-sandesh"
  }

  ingress {
    description = "Allow HTTP"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  ingress {
    description = "ALLOW SSH"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  ingress {
    description = "Django App Port"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8000
    to_port     = 8000
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

resource "null_resource" "ansible" {
  depends_on = [module.ec2]
  provisioner "local-exec" {
    command = <<EOT
    sleep 30
    echo "[ec2]" > ec2-ansible/inventory.ini
    echo ${module.ec2.public_ip} >> ec2-ansible/inventory.ini
    ansible-playbook -i ec2-ansible/inventory.ini ec2-ansible/playbook.yml -u ubuntu --private-key /Users/sandesh/Downloads/Key-Sandesh.pem --ssh-extra-args='-o StrictHostKeyChecking=no' -v
  EOT
  }
}
