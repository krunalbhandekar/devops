variable "usersAge" {
  type = map(any)
  default = {
    krunal = 20
    pratik = 25
  }
}

variable "username" {
  type = string
}

output "print-user-age" {
  value = "my name is ${var.username} and my age is ${lookup(var.usersAge, var.username)}"
}
