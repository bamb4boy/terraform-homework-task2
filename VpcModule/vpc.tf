# use aws internet gateway as variable
variable "aws_internet_gateway" {
  type = string
}

# create new VPC
resource "aws_vpc" "terra" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "terra"
  }
}

# output VPC ID as variable
output "vpc_id" {
  value = aws_vpc.terra.id
}

# Create a Private Subnet
resource "aws_subnet" "aws_private" {
  vpc_id     = aws_vpc.terra.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "aws_private"
  }
}
# output private subnet to use as variable
output aws_private {
  value = aws_subnet.aws_private
}

# Create a Public Subnet
resource "aws_subnet" "aws_public" {
  vpc_id     = aws_vpc.terra.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "aws_public"
  }
}
# output public subnet to use as variable
output aws_public {
  value = aws_subnet.aws_public
}
