#-----------------------------
# Create VPC
#-----------------------------
resource "aws_vpc" "osovpc" {
  cidr_block       = "20.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "osovpc"
  }
}

# subnet Creation

resource "aws_subnet" "oso_sub" {
  vpc_id     = aws_vpc.osovpc.id
  cidr_block = "20.0.1.0/24"

  tags = {
    Name = "oso_sub"
  }
}



resource "aws_route_table" "myRT" {
  vpc_id = aws_vpc.osovpc.id

  route {
    cidr_block = "0.0.0.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }

 tags = {
    Name = "my_rtd"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.osovpc.id

  tags = {
    Name = "oso_vpc"
  }
}

resource "aws_route_table_association" "my_rta" {
  subnet_id      = aws_subnet.oso_sub.id
  route_table_id = aws_route_table.myRT.id
}



+++++++++++++++
AWS KEY_PAIR
+++++++++++++++

resource "aws_key_pair" "mykey" {
  key_name    = "demokey"
  public_key  = "${file("${path.module}/demokey.pub")}"
