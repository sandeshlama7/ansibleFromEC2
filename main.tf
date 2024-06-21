module "ec2" {
  source              = "./modules/ec2"
  ami                 = "ami-0e001c9271cf7f3b9" #Ubuntu 22.04
  instance_type       = "t2.micro"
  subnet_id           = "subnet-0639d260294d92a5d"
  associate_public_ip = true
  vpc_id              = data.aws_vpc.vpc.id
  iam_profile         = data.aws_iam_instance_profile.iam.name
  ssh-key             = "Key-Sandesh"
  user_data           = file("./userdata.sh")
}

data "aws_vpc" "vpc" {
  id = "vpc-03d964f7cd3fa2c74"
}

data "aws_iam_instance_profile" "iam" {
  name = "SSM-Sandesh"
}
