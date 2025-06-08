variable "name" {
  type = string
}

variable "age" {
  type = number
}

output "print-userData" {
  value = "Hello, ${var.name}, your age is ${var.age}"
}
