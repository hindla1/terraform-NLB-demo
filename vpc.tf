resource "aws_vpc" "my-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "my-vpc"
  }

}


resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "my-igw"
  }

}


resource "aws_subnet" "my-pub-subnet" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "my-pub-subnet"
  }
}

resource "aws_subnet" "my-private-subnet" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "my-private-subnet"
  }
}



resource "aws_route_table" "my-pub-route-table" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
  tags = {
    Name = "my-pub-route-table"
  }


}


resource "aws_route_table" "my-private-route-table" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "my-private-route-table"
  }


}

resource "aws_route_table_association" "my-pub-association" {
  subnet_id      = aws_subnet.my-pub-subnet.id
  route_table_id = aws_route_table.my-pub-route-table.id
}

resource "aws_route_table_association" "my-private-association" {
  subnet_id      = aws_subnet.my-private-subnet.id
  route_table_id = aws_route_table.my-private-route-table.id
}



