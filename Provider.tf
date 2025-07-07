terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region     = "us-west-2"
  access_key = "AK**********"
  secret_key = "8EM*********"
}
