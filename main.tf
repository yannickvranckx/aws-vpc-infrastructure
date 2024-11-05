provider "aws" {
  region = local.region

  default_tags {
    tags = {
      created_with = "terraform"
      created_by   = "yannick.vranckx.ext@luminus.be"
      description  = "automic-acceptance"
      map-migrated = "mig39446"
      gitlab_repo  = "/luminusbe/automic/production/infrastructure-vpc-production"
    }
  }
}