terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.60.0"
    }
  }
  backend "s3" {
    bucket = "abhinak.fun-remote-state"
    key    = "remote-state-for-each" #can be any name
    region = "us-east-1"
    dynamodb_table = "abhinavk.fun-remote-state" #name is defined in dynamodb table
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}