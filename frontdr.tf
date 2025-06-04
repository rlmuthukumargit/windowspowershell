
resource "azurerm_dns_zone" "azdnszone" {
  name                = "rlmuthukumar.in"
  resource_group_name = var.resource_group_name
}
# Create Front Door Premium Profile
resource "azurerm_cdn_frontdoor_profile" "azfrdprofile" {
  name                = "fd-premium-profile"
  resource_group_name = var.resource_group_name
  sku_name            = "Premium_AzureFrontDoor"
}

# Create Front Door Endpoint
resource "azurerm_cdn_frontdoor_endpoint" "fdrendpoint" {
  name                     = "fd-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.azfrdprofile.id
  enabled                  = true
  }

# Backend origin group
resource "azurerm_cdn_frontdoor_origin_group" "fdrorgingroup" {
  name                     = "origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.azfrdprofile.id
  session_affinity_enabled = false
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 10
  health_probe {
    interval_in_seconds = 240
    path                = "/healthProbe"
    protocol            = "Https"
    request_type        = "HEAD"
  }

  load_balancing {
    additional_latency_in_milliseconds = 0
    sample_size                        = 16
    successful_samples_required        = 3
  }
}

# Origin (e.g., Azure Web App)
resource "azurerm_cdn_frontdoor_origin" "fdorgin" {
  name                          = "example-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fdrorgingroup.id
  enabled                       = true
  certificate_name_check_enabled = false

  host_name          = "rlmuthukumar.in"
  http_port          = 80
  https_port         = 443
  origin_host_header = "www.rlmuthukumar.in"
  priority           = 1
  weight             = 1
}

resource "azurerm_cdn_frontdoor_rule_set" "fdruleset" {
  name                     = "FDRuleSet"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.azfrdprofile.id
}
resource "azurerm_cdn_frontdoor_custom_domain" "customdomain" {
  name                     = "fabrikam-custom-domain"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.azfrdprofile.id
  dns_zone_id              = azurerm_dns_zone.azdnszone.id
  host_name                = join(".", ["customdomain", azurerm_dns_zone.azdnszone.name])

  tls {
    certificate_type    = "ManagedCertificate"
    minimum_tls_version = "TLS12"
  }
}
# Route
resource "azurerm_cdn_frontdoor_route" "frdroute" {
  name                          = "example-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fdrendpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fdrorgingroup.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.fdorgin.id]
  cdn_frontdoor_rule_set_ids    = [azurerm_cdn_frontdoor_rule_set.fdruleset.id]
  enabled                       = true

  forwarding_protocol    = "HttpsOnly"
  https_redirect_enabled = true
  patterns_to_match      = ["/*"]
  supported_protocols    = ["Http", "Https"]

  cdn_frontdoor_custom_domain_ids = [
    azurerm_cdn_frontdoor_custom_domain.customdomain.id
  ]
  link_to_default_domain          = false

  cache {
    query_string_caching_behavior = "IgnoreSpecifiedQueryStrings"
    query_strings                 = ["account", "settings"]
    compression_enabled           = true
    content_types_to_compress     = ["text/html", "text/javascript", "text/xml"]
  }
}

