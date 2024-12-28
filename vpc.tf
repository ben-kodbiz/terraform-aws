# ----------------------
# Create a VPC
# ----------------------
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main-vpc"
  }
}

# ----------------------
# Create Internet Gateway
# ----------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
  }
}

# -------------------------------------------
# Create Public Subnet
# -------------------------------------------

resource "aws_subnet" "public_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone_a
  tags = {
    Name = "public-subnet-a"
  }
}

# -------------------------------------------
# Create Private Subnets
# -------------------------------------------
resource "aws_subnet" "private_app_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = var.availability_zone_a
    tags = {
    Name = "private-app-subnet-a"
  }
}

resource "aws_subnet" "private_web_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = var.availability_zone_a
    tags = {
    Name = "private-web-subnet-a"
  }
}

resource "aws_subnet" "private_db_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.7.0/24"
  availability_zone = var.availability_zone_a
    tags = {
    Name = "private-db-subnet-a"
  }
}


# -------------------------------------------
# Create Route Tables
# -------------------------------------------

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.main.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "public-route-table"
    }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "private-route-table"
  }
}

# -------------------------------------------
# Associate Subnets to Route Tables
# -------------------------------------------
resource "aws_route_table_association" "public_subnet_a_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}



resource "aws_route_table_association" "private_app_subnet_a_rt_assoc" {
  subnet_id      = aws_subnet.private_app_subnet_a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_web_subnet_a_rt_assoc" {
  subnet_id      = aws_subnet.private_web_subnet_a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_db_subnet_a_rt_assoc" {
  subnet_id      = aws_subnet.private_db_subnet_a.id
  route_table_id = aws_route_table.private_route_table.id
}