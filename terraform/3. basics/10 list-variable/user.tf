variable "users" {
  type = list(any)
}

output "printUsers" {
  value = "First User is ${var.users[0]}"
}
