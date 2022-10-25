terraform {
  cloud {
    organization = "btc-brian"

    workspaces {
      name = "Brians-workspace"
    }
  }
}