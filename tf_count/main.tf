provider "aws" {
   region = "us-east-1"
}

variable "usernames" {
   type = list
   
   default = [
      "neo",
      "leonardo",
      "rodrigo",
      "belmiro",
 ]
}

resource "aws_iam_user" "users" {
   count = length(var.usernames)
   name = var.usernames[count.index]
}

