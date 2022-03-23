variable "curso" {
   type = string
}

variable "pacotes" {
   default = ["docker","vim"]
}

variable "pacotes" {
   type = list
   default = ["docker.io", "via"]
}

data "template_file" "user_data" {
    template = file("user_data.sh")
    vars = {
          curso = var.curso
          pacotes = join(" ",var.pacotes)
 }
}

output "user_data" {
   value = data.template_file.user_data.rendered
}
