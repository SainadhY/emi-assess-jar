provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket         = "java-home-tf"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "java-home-tf-table"
  }
}
