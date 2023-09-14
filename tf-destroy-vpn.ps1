Set-Location $pwd\Terraform
terraform plan -destroy -target="azurerm_virtual_network_gateway.rtlab_vpn" -out destroy.vpn.tfplan
terraform apply destroy.vpn.tfplan