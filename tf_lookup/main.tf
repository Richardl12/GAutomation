variable "env" {
   type = string
}



variable "size" {
    type = map
    default = {
       "qa" = "Large",
       "dev" = "small",
       "prod" = "xLarge"
  }
}

variable "rds_multiaz" {
  type = map
  default = { 
    "dev" = "false",
    "qa" = "true",
    "prod" = "true",
 } 
}
output "type" {
  value = lookup(var.size, var.env)
}

output "rds_ha" {
  value = lookup(var.rds_multiaz, var.env)
}

