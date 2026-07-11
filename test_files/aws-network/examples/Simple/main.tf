module "network" {
  source = "../../"
}

output "network" {
  value = module.network
}
