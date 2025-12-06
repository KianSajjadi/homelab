terraform {
  backend "local" {
    path = "terraform.tfstate"
  }

  required_version = ">= 1.5.7"

  providers = {
    aws = {
      region = "ap-southeast-2"
    }
  }
}