variable "name" {
  type = string
}

output "print-name" {
  value = "Hello, ${var.name}"
}
