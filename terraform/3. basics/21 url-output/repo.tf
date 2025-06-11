provider "github" {
  token = "<write-your-github-token-here>"
}

resource "github_repository" "terraform-repo-1" {
  name        = "first-repo-using-terraform"
  description = "My First repo using Terraform"
  visibility  = "public"
  auto_init   = true
}


output "print-git-repo-url" {
  value = github_repository.terraform-repo-1.html_url
}
