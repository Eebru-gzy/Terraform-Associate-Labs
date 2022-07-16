terraform {
  cloud {
    organization = "Eebru"

    workspaces {
      name = "test-sentinel"
    }
  }
}

provider "aws" {
  # profile = "default"
  region  = "eu-west-3"
}

# data "terraform_remote_state" "vpc" {
# 	backend = "local"
# 	config = {
# 		path = "../project1/terraform.tfstate"
# 	}
# }

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-terraform-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false
}

module "apache" {
  source          = "ExamProCo/apache-example/aws"
  version         = "1.1.0"
  vpc_id          = module.vpc.vpc_id
  my_ip_with_cidr = var.my_ip_with_cidr
  public_key      = var.public_key
  instance_type   = var.instance_type
  server_name     = var.server_name
}

output "public_ip" {
  value = module.apache.public_ip
}