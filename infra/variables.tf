variable "region" {
  description = "Region where resources are deployed"
  type    = string
}

variable "env_name" {
  description = "environment name"
  type    = string
}

variable "project_name" {
  description = "environment name"
}

variable "vpc_name" {
  description = "VPC name"
}


variable "security_group_backend" {
  description = "ec2 security group name"
  type        = string

}

variable "database_name" {
  description = "DB name"
  type        = string
}

variable "database_identifier" {
  description = "DB name"
  type        = string

}

variable "database_instance_type" {
  description = "RDS instance type"
  type        = string

}

variable "database_engine" {
  description = "DB engine"
  type        = string

}

variable "database_version" {
  description = "DB version"
  type        = string

}

variable "security_group_name_RDS" {
  description = "security group name RDS"
  type        = string

}


variable "database_username" {
  type    = string
}

variable "database_password" {
  type    = string
}

variable "db_subnet_group_name" {
  description = "subnet group name"
  type        = string

}

#variable "backend_s3_name" {
#  description = "backend s3 bucket name"
#  type        = string
#  default     = "demo-be-prod"

#}


variable "ecs_cluster_name" {
  type    = string
}

variable "ecs_service_name" {
  type    = string
}


variable "ecs_container_name" {
  type    = string
}



# variable "ecs_cluster" {}

# variable "ecs_service" {}

#code pipeline
variable "aws_account_id" {
    type    = string
}


variable "image_repo_url" {
    type    = string
}
variable "repo_owner" {
    type    = string
}
variable "repo_name" {
    type    = string
}
variable "branch" {
    type    = string
}

variable "build_project" {
  type    = string
}
