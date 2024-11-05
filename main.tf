provider "aws" {
  region = local.region

  default_tags {
    tags = {
      created_with = "terraform"
      created_by   = "tag"
      description  = "tag"
      map-migrated = "tag"
      gitlab_repo  = "tag"
    }
  }
}
