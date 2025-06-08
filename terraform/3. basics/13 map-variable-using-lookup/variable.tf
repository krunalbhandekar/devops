variable "usersAge" {
  type = map(any)
  default = {
    krunal = 20
    pratik = 20
  }
}

output "print-user-age" {
  value = "my name is krunal and my age is ${lookup(var.usersAge, "krunal")}"
}
