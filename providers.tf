provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      owner     = "sandesh.lama@adex.ltd"
      silo      = "intern"
      terraform = "true"
    }
  }
}
