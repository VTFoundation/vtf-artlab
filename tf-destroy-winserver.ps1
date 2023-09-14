Set-Location $pwd\Terraform
terraform plan -destroy -target="azurerm_windows_virtual_machine.winserver" -out destroy.winserver.tfplan
terraform apply destroy.winserver.tfplan