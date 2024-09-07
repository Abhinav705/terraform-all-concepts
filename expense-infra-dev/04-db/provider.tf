terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.59.0, < 6.0.0"
    }
  }
  backend "s3" {
    bucket = "abhinak.fun-remote-state"
    key    = "terraform-db" #can be any name
    region = "us-east-1"
    dynamodb_table = "abhinavk.fun-remote-state" #name is defined in dynamodb table
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}