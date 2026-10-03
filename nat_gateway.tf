resource "aws_eip" "sprint1_terra_nat_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.sprint1_terra_igw]

  tags = {
    Name = "sprint1_nat_eip"
  }
}

resource "aws_nat_gateway" "sprint1_terra_nat_gw" {
  allocation_id = aws_eip.sprint1_terra_nat_eip.id
  subnet_id     = aws_subnet.sprint1_terra_public_subnet.id
  depends_on    = [aws_internet_gateway.sprint1_terra_igw]

  tags = {
    Name = "sprint1_nat_gw"
  }
}
