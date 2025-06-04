resource "azurerm_frontdoor_rules_engine" "example_rules_engine" {
  name                = "devruleengine"
  frontdoor_name      = azurerm_cdn_frontdoor_profile.azfrdprofile.name
  resource_group_name = var.resource_group_name

  rule {
    name     = "RuleA"
    priority = 1

    action {
      response_header {
        header_action_type = "Overwrite"
        header_name        = "X-Frame-Options"
        value              = "SAMEORIGIN"
      }
      response_header {
        header_action_type = "Overwrite"
        header_name        = "X-Xss-Protection"
        value              = "1;mode=block"
      }
      response_header {
        header_action_type = "Overwrite"
        header_name        = "Strict-Transport-Security"
        value              = "max-age=31536000; includeSubDomains; preload"
      }
      response_header {
        header_action_type = "Overwrite"
        header_name        = "X-Content-Type-Options"
        value              = "nosniff"
      }
      response_header {
        header_action_type = "Overwrite"
        header_name        = "Content-Security-Policy"
        value              = "upgrade-insecure-requests; base-uri 'self'; frame-ancestors 'self'; form-action 'self'; object-src 'none';"
      }
    }
  }

  rule {
    name     = "RuleB"
    priority = 2
      action {
        response_header {
          header_action_type = "Overwrite"
          header_name        = "X-Frame-Options"
          value              = "SAMEORIGIN"
        }
        response_header {
          header_action_type = "Overwrite"
          header_name        = "X-Xss-Protection"
          value              = "1;mode=block"
        }
        response_header {
          header_action_type = "Overwrite"
          header_name        = "Strict-Transport-Security"
          value              = "max-age=31536000; includeSubDomains; preload"
        }
      }
    }
  }