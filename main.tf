# Author : Gaus M. Ahmed || Date: 15 Feb 2023
#Provider
provider "aws"{
    region = "ap-south-1"
}
#1. Create VPC
resource "aws_vpc" "Thanos"{
    cidr_block = "10.0.0.0/16"
    tags = {
        "name" = "Thanos"
    }
}

#2. Create a public subnet
resource "aws_subnet" "Public" {
    vpc_id = aws_vpc.Thanos.id
    availability_zone = "ap-south-1c"
    cidr_block = "10.0.1.0/24"
}

#3. Create a private subnet
resource "aws_subnet" "Private" {
    vpc_id = aws_vpc.Thanos.id
    # availability_zone = "ap-south-1"
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = true
}

#4. Create an Internet Gateway
resource "aws_internet_gateway" "vpc-gateway" {
    vpc_id = aws_vpc.Thanos.id
}

#5. Route table for public subnet
resource "aws_route_table" "PublicRT" {
    vpc_id = aws_vpc.Thanos.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.vpc-gateway.id
    }
}

#6. Route table association with public subnets
resource "aws_route_table_association" "vpc-association" {
    subnet_id = aws_subnet.Public.id
    route_table_id = aws_route_table.PublicRT.id
}
