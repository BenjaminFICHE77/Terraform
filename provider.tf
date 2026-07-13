terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# la région aws ou nous voulons déployer nos différentes ressources
provider "aws" {
  region     = "eu-west-3"
}