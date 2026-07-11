resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name       = "${var.application_name}_private_rt"
    managed_by = "terraform"
  }
}

resource "aws_route" "private" {
  count = var.enable_internet_connectivity ? 1 : 0

  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw[0].id
}

resource "aws_route_table" "public" {
  count = var.enable_internet_connectivity ? 1 : 0

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name       = "${var.application_name}_public_rt"
    managed_by = "terraform"
  }
}

resource "aws_route" "public" {
  count = var.enable_internet_connectivity ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[0].id
}
