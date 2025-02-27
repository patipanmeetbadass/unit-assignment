# Create VPC and VPC endpoints for S3 and EC2
################################################################################
# VPC
################################################################################
module "vpc" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "5.8.1"
    name = "vpc-${var.env_name}"
    cidr = "10.0.0.0/16"
    azs  = var.aws_availability_zones
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
    # Allows private instances to reach the internet
    enable_nat_gateway   = true
    single_nat_gateway   = true
    # Allows private instances to resolve domain names
    enable_dns_hostnames = true
    enable_vpn_gateway = false
    # To support EC2 instances in public subnet, these options are required
    create_igw = true
    map_public_ip_on_launch = true
    # To allow EKS to automatically manage Load Balancers
    public_subnet_tags = {
        "kubernetes.io/role/elb" = 1
    }
    private_subnet_tags = {
        "kubernetes.io/role/internal-elb" = 1
    }
    tags = {
        Resource = "vpc"
        Environment = var.env_name
    }
}


################################################################################
# VPC Endpoint
# Secure connectivity between resources inside a VPC and specific AWS services
################################################################################
module "vpc_endpoints" {
    source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
    vpc_id = module.vpc.vpc_id
    endpoints = {
        s3 = {
            service             = "s3"
            private_dns_enabled = true
            tags                = { Name = "s3-vpc-endpoint" }
        },
        ec2 = {
            service             = "ec2"
            private_dns_enabled = true
            tags                = { Name = "ec2-vpc-endpoint" }
        }
    }
    tags = {
        Resource = "vpc_endpoint"
        Environment = var.env_name
    }
}

