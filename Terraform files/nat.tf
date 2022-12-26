resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "Elastic IP"
  }
}

resource "aws_eip" "nat2" {
  vpc = true

  tags = {
    Name = "Elastic IP2"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_us_east_1a.id

  tags = {
    Name = "Nat Gateway"
  }

  depends_on = [aws_internet_gateway.internet_gateway]
}


resource "aws_nat_gateway" "nat2" {
  allocation_id = aws_eip.nat2.id
  subnet_id     = aws_subnet.public_us_east_1b.id
  tags = {
    Name = "Nat Gateway2"
  }

  depends_on = [aws_internet_gateway.internet_gateway]
}