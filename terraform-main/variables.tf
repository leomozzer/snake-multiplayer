variable "rg_location" {
  description = "Resource group location"
}

variable "repo_url" {
  description = "GitHub repository where the app is located"
}

variable "stage" {
  description = "Stage that the app will be deployed (dev, prod, test)"
}
