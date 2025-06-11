provider "github" {
  token = "<write-your-github-token-here>"
}



resource "github_repository" "terraform-repo-1" {
  name        = "first-repo-using-terraform"
  description = "My First repo using Terraform"
  visibility  = "public"
  auto_init   = true
}

resource "github_repository" "terraform-repo-2" {
  name        = "second-repo-using-terraform"
  description = "My Second repo using Terraform"
  visibility  = "public"
  auto_init   = true
}
