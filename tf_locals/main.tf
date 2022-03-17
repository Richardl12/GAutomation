variable "resource_tags" {
    type = map(string)
    default = {}
}

locals {
  required_tags = {
      "project" = "impacta",
      "environment" = "prod"
      "cc" = "142789776"
      "tag_uuid" = format("%s_%s", var.projeto, var.env)  
}
  
  tags = merge(var.resource_tags, local.required_tags)
}


variable "projeto" {
}


variable "env" {
}


output "tags" {
  value = local.tags
}
