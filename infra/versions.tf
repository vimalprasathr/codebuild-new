terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.31.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.1.1"
    }


  }

  required_version = "~> 1.0"
}
