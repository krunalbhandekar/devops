variable "first-variable-name" {}

output "printName" {
  value = var.first-variable-name
}

output "printName-in-string-format" {
  value = "Check, ${var.first-variable-name}"
}
