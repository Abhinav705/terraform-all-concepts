resource "aws_vpc_peering_connection" "peering" {
  count = var.is_peering_required ? 1 : 0
  #we will ask if user needs peering or not. if he pass the input as true then count would be 1, otherwise 0 then code will not execute
  #if it is 1 then below lines of code will be executed and peering connection will be created. 
  vpc_id        = aws_vpc.main.id
  peer_vpc_id   = var.acceptor_vpc_id == "" ? data.aws_vpc.default.id : var.acceptor_vpc_id
  #peer vpc id is nothing but acceptor vpc id. we should ask user for the acceptor vpc id. 
  #if user doesn't give any input then it will take default vpc id
  auto_accept = var.acceptor_vpc_id == "" ? true : false
  #if acceptor vpc is default, we can directly enable auto accept as true
  tags = merge(
    var.common_tags,
    var.vpc_peering_tags,
    {
        Name = "${local.resource_name}" #expense-dev
    }
  )
}

#create routes from route table
resource "aws_route" "public_peering" {
  count = var.acceptor_vpc_id == "" && var.is_peering_required ? 1 : 0
  #above count checks if user required peering connection or not 
  # and checks if the acceptor vpc is empty, then we will establish peering connection with def vpc
  route_table_id            = aws_route_table.public.id #public route table cidr
  destination_cidr_block    = data.aws_vpc.default.cidr_block #def vpc cidr block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
  #the above peering resource contains count variable, so it returns the output as list. 
  #so, if we need to access the peering resource, then we should use indexing to fetch the id 
  #in the above scenario, we have only one peering conn, so we just keep index as 0
}

resource "aws_route" "private_peering" {
  count = var.acceptor_vpc_id == "" && var.is_peering_required ? 1 : 0
  #above count checks if user required peering connection or not 
  # and checks if the acceptor vpc is empty, then we will establish peering connection with def vpc
  route_table_id            = aws_route_table.private.id #private route table cidr
  destination_cidr_block    = data.aws_vpc.default.cidr_block #def vpc cidr block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
  #the above peering resource contains count variable, so it returns the output as list. 
  #so, if we need to access the peering resource, then we should use indexing to fetch the id 
  #in the above scenario, we have only one peering conn, so we just keep index as 0
}

resource "aws_route" "database_peering" {
  count = var.acceptor_vpc_id == "" && var.is_peering_required ? 1 : 0
  #above count checks if user required peering connection or not 
  # and checks if the acceptor vpc is empty, then we will establish peering connection with def vpc
  route_table_id            = aws_route_table.database.id #database route table cidr
  destination_cidr_block    = data.aws_vpc.default.cidr_block #def vpc cidr block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
  #the above peering resource contains count variable, so it returns the output as list. 
  #so, if we need to access the peering resource, then we should use indexing to fetch the id 
  #in the above scenario, we have only one peering conn, so we just keep index as 0
}

# we have created routes from expense vpc for peering conn 
#below code is for create routes from other vpc side (default vpc in this case)

resource "aws_route" "default_peering" {
  count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
  route_table_id            = data.aws_route_table.main.id # default vpc route table
  destination_cidr_block    = var.vpc_cidr_block#expense vpc cidr 
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}