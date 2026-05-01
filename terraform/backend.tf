terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "todo-application-01052026"
    key            = "jenkins-server/terraform.tfstate"
    region         = "ap-south-2"
    dynamodb_table = "Lock-Files"
    encrypt        = true
  }
}