terraform {
  required_version = "~>1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0.0"
    }
  }
  backend "s3" {
    bucket         = "statefileofmine"
    key            = "terraform-state-file"
    region         = "us-east-1"
    role_arn       = "arn:aws:iam::576096981613:role/stsAssume"
    dynamodb_table = "terraformtable"


  }

}



provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn     = "arn:aws:iam::576096981613:role/stsAssume"
    session_name = "mysession"
  }
}






 