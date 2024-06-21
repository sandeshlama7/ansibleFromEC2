terraform {
  backend "s3" {
    bucket = "8586-terraform-state"
    key    = "sandesh/modules.tfstate"
    region = "us-east-1"
  }
}
