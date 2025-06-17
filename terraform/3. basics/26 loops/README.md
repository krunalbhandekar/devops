# Terraform Loops Example

This repository demonstrates how to use different types of **Loops in Terraform**, including:

- `count`
- `for_each`
- `for` expression
- Conditional Loops
- Nested map loops

---

## 1. `count` - Loop with index

```hcl
resource "aws_instance" "web" {
  count         = 3
  ami           = "<write-valid-ami>"
  instance_type = "t2.micro"

  tage = {
    Name = "web-${count.index}"
  }
}
```

---

## 2. `for_each` - Loop over Map or Set

```hcl
variable "bucket_names" {
  default = ["dev", "test", "prod"]
}

resource "aws_s3_bucket" "buckets" {
  for_each = toset(var.bucket_names)

  bucket = "${each.value}-bucket"
  acl    = "private"
}
```

---

## 3. `for` Expression - Loop in Variable

**Example:** Add prefix to a list of names

```hcl
variable "users" {
  default = ["krunal", "raj", "sam"]
}

output "dev_usernames" {
  value = [for user in var.users : "dev-${user}"]
}
```

**Output:** `["dev-krunal", "dev-raj", "dev-sam"]`

---

## 4. `for` + `if` - Conditional Loop

**Example:** Filter even numbers

```hcl
output "even_numbers" {
  value = [for n in [1, 2, 3, 4, 5] : n if n % 2 === 0]
}
```

**Output:** `[2, 4]`

---

## 5. `for_each` with Map - IAM Users

**Example:** Create IAM users with custom names & tags

```hcl
variable "iam_users" {
  default = {
    "krunal" = "admin"
    "raj"    = "developer"
    "sam"    = "tester"
  }
}

resource "aws_iam_user" "users" {
  for_each = var.iam_users

  name = each.Key

  tags = {
    Role = each.value
  }
}
```

---

### 👨‍💻 Author

Maintained by **[Krunal Bhandekar](https://www.linkedin.com/in/krunal-bhandekar/)**

---
