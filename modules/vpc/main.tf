resource "aws_vpc" "this" {
  enable_dns_hostnames = true
  enable_dns_support   = true
  cidr_block           = var.vpc_cidr_block

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_eip" "eip" {
  domain = "vpc"
  count = length(var.private_subnet_cidrs)

  tags = {
    Name = "${var.project_name}-nat-eip-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.this.id
  subnet_ids = aws_subnet.public[*].id

  ingress {
    protocol = "tcp"
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 10
    to_port = 65535
  }

  tags = {
    Name = "${var.project_name}-public-nacl"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = element(var.azs, count.index)

  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "this" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_nat_gateway" "nat_gw" {
  count = length(var.private_subnet_cidrs)
  allocation_id = aws_eip.eip[count.index].id
  subnet_id = aws_subnet.public[count.index].id
  
  tags = {
    Name = "${var.project_name}-nat-gw-${count.index + 1}"
  }

  depends_on = [ aws_internet_gateway.igw ]
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.this.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.project_name}-private-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "private_rt" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }

  tags = {
    Name = "${var.project_name}-private-rt-${count.index}"
  }
}

resource "aws_route_table_association" "private_table_asso" {
  count = length(var.private_subnet_cidrs)
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}