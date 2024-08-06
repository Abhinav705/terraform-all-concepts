resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  enable_dns_support = var.dns_support
  tags = merge(
    var.common_tags,
    var.vpc_tags,
    {
        Name = local.resource_name
    }
  )
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.igw_tags,
    {
        Name = local.resource_name
    }
  )
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true #we need public ip for our project. so we are enabling it
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]

  tags = merge(
    var.common_tags,
    var.public_subnet_cidr_tags,
    {
        Name = "${local.resource_name}-public-${local.az_names[count.index]}" #resourcename-public-<us-east-1a>/<us-east-1b>
    }
  )
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  availability_zone = local.az_names[count.index]
  #map_public_ip_on_launch = true #we don't need public ip for private subnet
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]

  tags = merge(
    var.common_tags,
    var.private_subnet_cidr_tags,
    {
        Name = "${local.resource_name}-private-${local.az_names[count.index]}" #resourcename-private-<us-east-1a>/<us-east-1b>
    }
  )
}

resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)
  availability_zone = local.az_names[count.index]
  #map_public_ip_on_launch = true #we don't need public ip for database subnet
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidrs[count.index]

  tags = merge(
    var.common_tags,
    var.database_subnet_cidr_tags,
    {
        Name = "${local.resource_name}-database-${local.az_names[count.index]}" #resourcename-database-<us-east-1a>/<us-east-1b>
    }
  )
}

#creating a group of database subnets
resource "aws_db_subnet_group" "default" {
  name       = "${local.resource_name}"
  subnet_ids = aws_subnet.database[*].id

  tags = merge(
    var.common_tags,
    var.database_subnet_group_tags,
    {
        Name = "${local.resource_name}"
    }
  )
}

resource "aws_eip" "eip" { #creating elastic ip and maping it to NAT gateway
  domain   = "vpc"
    tags = merge(
    var.common_tags,
    var.eip_tags,
    {
        Name = "${local.resource_name}"
    }
  )
}
#creating nat gateway and mapping it to one of the public subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id # we are mapping only one public subnet from only (us-east-1a)
  #because nat gateway charges are huge. so we are mapping only one public subnet from one region.
  tags = merge(
    var.common_tags,
    var.nat_gateway_tags,
    {
        Name = "${local.resource_name}" #expense-dev
    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
  #nat gateway resource is dependent on internet gatweay. so we are explicitly mentioning that
  #if you didn't create internet gateway, then create one and execute nat gateway resource
}

#creating route tables for public,private and database
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags =  merge(
    var.common_tags,
    var.public_route_table_tags,
    {
        Name = "${local.resource_name}-public" 
    }
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags =  merge(
    var.common_tags,
    var.private_route_table_tags,
    {
        Name = "${local.resource_name}-private" 
    }
  )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id
  tags =  merge(
    var.common_tags,
    var.database_route_table_tags,
    {
        Name = "${local.resource_name}-database" 
    }
  )
}

#creating routes for the route tables
resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0" # we call it as public route when it is attached to the internet gateway
  #so we are attaching internet gateway cidr block to public route
  gateway_id = aws_internet_gateway.gw.id
  #we are mentioning internet gateway id to the public route table
}
resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0" #private subnet needs to connect to internet through nat gateway. 
  #so we are mentioning internet gateway cidr and mapping it to nat gateway
  nat_gateway_id = aws_nat_gateway.nat.id
  #we are mentioning nat gateway id to the private route table
}
resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"#database subnet needs to connect to internet through nat gateway.
  #so we are mentioning internet gateway cidr and mapping it to nat gateway
  nat_gateway_id = aws_nat_gateway.nat.id
  #we are mentioning nat gateway id to the database route table
}

#adding subnets to the route tables
resource "aws_route_table_association" "public" {
  # we need to map route tables to subnets for both the regions.
  #so we are taking length of each subnet in all the regions and traversing
  count = length(var.public_subnet_cidrs)
  #element function fetches single element from the list
  #we are fetching each subnet id individually from the list 
  subnet_id      = element(aws_subnet.public[*].id,count.index)
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private[*].id,count.index)
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidrs)
  subnet_id      = element(aws_subnet.database[*].id,count.index)
  route_table_id = aws_route_table.database.id
}