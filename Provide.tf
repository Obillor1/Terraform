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
  access_key = "AKIAUAFTLIVUPBTKZMTV"
  secret_key = "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"
}
