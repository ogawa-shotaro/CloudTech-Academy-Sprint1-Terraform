resource "aws_security_group" "sprint1_terra_web_sg" {
  name        = "sprint1_web_sg"
  description = "Web server SG: allow port 80 from internet only"
  vpc_id      = aws_vpc.sprint1_terra_vpc.id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sprint1_web_sg"
  }
}

resource "aws_security_group" "sprint1_terra_api_sg" {
  name        = "sprint1_api_sg"
  description = "API server SG: allow port 8080 from web server SG only, no direct internet access"
  vpc_id      = aws_vpc.sprint1_terra_vpc.id

  ingress {
    description     = "8080 from web server only"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.sprint1_terra_web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sprint1_api_sg"
  }
}
