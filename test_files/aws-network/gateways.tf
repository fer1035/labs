resource "aws_internet_gateway" "igw" {
  count = var.enable_internet_connectivity ? 1 : 0

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name       = "${var.application_name}_igw"
    managed_by = "terraform"
  }
}

resource "aws_eip" "eip" {
  #checkov:skip=CKV2_AWS_19:This is for a VPC.
  count = var.enable_internet_connectivity ? 2 : 0

  domain = "vpc"
  # network_interface = aws_network_interface.nat_eni.id

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = {
    Name       = "${var.application_name}_eip"
    managed_by = "terraform"
  }
}

# The regional NAT Gateway creates its own Route Table, which can be referenced as:
# aws_nat_gateway.nat_gw.route_table_id
resource "aws_nat_gateway" "nat_gw" {
  count = var.enable_internet_connectivity ? 1 : 0

  availability_mode = var.nat_availability_mode
  allocation_id     = var.nat_availability_mode == "zonal" ? aws_eip.eip[0].id : null
  subnet_id         = var.nat_availability_mode == "zonal" ? aws_subnet.public_1[0].id : null
  vpc_id            = var.nat_availability_mode == "regional" ? aws_vpc.vpc.id : null

  dynamic "availability_zone_address" {
    for_each = var.nat_availability_mode == "regional" ? [0, 1] : []

    content {
      allocation_ids    = [aws_eip.eip[availability_zone_address.value].id]
      availability_zone = local.public_subnet_azs[availability_zone_address.value]
    }
  }

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = {
    Name       = "${var.application_name}_nat_gw"
    managed_by = "terraform"
  }
}

# resource "aws_egress_only_internet_gateway" "egress" {
#   vpc_id = aws_vpc.vpc.id
# }
