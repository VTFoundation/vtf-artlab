Set-Location $pwd\Terraform

Write-Host "Validating files for syntax errors" -Foreground "Blue"
terraform validate

terraform plan -target="azurerm_virtual_network_gateway.rtlab_vpn" -out deploy.vpn.tfplan
terraform apply deploy.vpn.tfplan

Write-Host "Generating VPN client configuration files" -Foreground "Blue"
$profile=New-AzVpnClientConfiguration -ResourceGroupName "RTLAB" -Name "RTLAB-vpn" -AuthenticationMethod "EapTls"
$profile.VPNProfileSASUrl