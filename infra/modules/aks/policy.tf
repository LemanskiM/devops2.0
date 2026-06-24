resource "azurerm_policy_definition" "deny_lb_except_ingress" {
  name         = "deny-lb-except-ingress-nginx"
  policy_type  = "Custom"
  mode         = "All"

  display_name = "Deny LoadBalancer Services in AKS"

  policy_rule = <<POLICY
{
  "if": {
    "allOf": [
      {
        "field": "type",
        "equals": "Microsoft.Network/loadBalancers"
      }
    ]
  },
  "then": {
    "effect": "deny"
  }
}
POLICY
}