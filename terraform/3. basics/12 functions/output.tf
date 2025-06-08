output "printUsers" {
  value = join(",", var.users)
}

output "print-in-first-user-UpperCase" {
  value = upper(var.users[0])
}

output "print-in-first-user-LowerCase" {
  value = lower(var.users[0])
}
