resource "aws_subnet" "private" {
  for_each = var.subnets_private

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = false
  availability_zone       = each.value.az

  tags = {
    Name       = "${var.application_name}_${each.key}_subnet"
    managed_by = "terraform"
  }
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

resource "aws_subnet" "public_1" {
  #checkov:skip=CKV_AWS_130:This is a public Subnet.
  count = var.enable_internet_connectivity ? 1 : 0

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_public_1_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.subnet_public_1_az

  tags = {
    Name       = "${var.application_name}_public_1_subnet"
    managed_by = "terraform"
  }
}

resource "aws_route_table_association" "public_1" {
  count = var.enable_internet_connectivity ? 1 : 0

  subnet_id      = aws_subnet.public_1[0].id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_subnet" "public_2" {
  #checkov:skip=CKV_AWS_130:This is a public Subnet.
  count = var.enable_internet_connectivity ? 1 : 0

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_public_2_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.subnet_public_2_az

  tags = {
    Name       = "${var.application_name}_public_2_subnet"
    managed_by = "terraform"
  }
}

resource "aws_route_table_association" "public_2" {
  count = var.enable_internet_connectivity ? 1 : 0

  subnet_id      = aws_subnet.public_2[0].id
  route_table_id = aws_route_table.public[0].id
}
