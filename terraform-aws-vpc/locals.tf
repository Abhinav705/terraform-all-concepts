locals {
  resource_name = "${var.project_name}-${var.environment}"
  az_names = slice(data.aws_availability_zones.available.names,0,2)
  #fetching all the zones from us-east1-region and taking only first 2 zones using slice indexing
}