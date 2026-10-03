resource "aws_route_table" "sprint1_terra_public_rt" {
  vpc_id = aws_vpc.sprint1_terra_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sprint1_terra_igw.id
  }

  tags = {
    Name = "sprint1_public_rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.sprint1_terra_public_subnet.id
  route_table_id = aws_route_table.sprint1_terra_public_rt.id
}

resource "aws_route_table" "sprint1_terra_private_rt" {
  vpc_id = aws_vpc.sprint1_terra_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.sprint1_terra_nat_gw.id
  }

  tags = {
    Name = "sprint1_private_rt"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.sprint1_terra_private_subnet.id
  route_table_id = aws_route_table.sprint1_terra_private_rt.id
}
