resource "azurerm_application_gateway" "network" {
  # Drata: Set [azurerm_application_gateway.backend_http_settings.connection_draining.enabled] to true to allow in-flight requests to complete and prevent new requests from being accepted when instances are being taken offline. Configure timeout settings for existing connections to prevent dropped requests
  # Drata: Specify [azurerm_application_gateway.ssl_policy] to ensure strong and secure TLS/SSL cipher suites are being used for data in transit encryption. Select a predefined or custom policy type depending on the cipher suite requirements for your use-case
  name                = "example-appgateway"
  resource_group_name = "example-resourceGroup"
  location            = "example --West-US"

  sku {
    name     = "Standard_Small"
    tier     = "Standard" # Drata: sku.tier should be set to any of Standard_V2, WAF_V2 # Drata: sku.tier should be set to any of Standard_V2, WAF_V2
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = "your subnet id"
  }

  frontend_port {
    name = "name"
    port = "port-no"
  }
  ####Missing WAF block: As per azure best practices, it is important to have a web application firewall enabled at application gateway.


  frontend_ip_configuration {
    name                 = "name"
    public_ip_address_id = "Ip-address"
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "https"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
  tags = {
    git_commit           = "b07a42ebd74b8f0ba647e20b872474b1c29b4814"
    git_file             = "terraform/azure/application_gateway.tf"
    git_last_modified_at = "2021-05-02 10:08:55"
    git_last_modified_by = "nimrodkor@users.noreply.github.com"
    git_modifiers        = "harkiratbhardwaj/nimrodkor"
    git_org              = "bridgecrewio"
    git_repo             = "terragoat"
    yor_trace            = "3f62753b-3d20-4fa7-b402-b780234a14d8"
  }
}
