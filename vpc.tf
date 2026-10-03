resource "aws_vpc" "sprint1_terra_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "sprint1_vpc"
  }
}

resource "aws_internet_gateway" "sprint1_terra_igw" {
  vpc_id = aws_vpc.sprint1_terra_vpc.id

  tags = {
    Name = "sprint1_igw"
  }
}
