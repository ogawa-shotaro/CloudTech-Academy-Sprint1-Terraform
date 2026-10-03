resource "aws_subnet" "sprint1_terra_public_subnet" {
  vpc_id                  = aws_vpc.sprint1_terra_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "sprint1_public_subnet"
  }
}

resource "aws_subnet" "sprint1_terra_private_subnet" {
  vpc_id                  = aws_vpc.sprint1_terra_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "sprint1_private_subnet"
  }
}
