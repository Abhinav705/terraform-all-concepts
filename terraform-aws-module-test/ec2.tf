module "module-test" {
  source = "../modules"
  instance_type = "t3.small" #this will overrwrite the value from original code declared inside module folder
}