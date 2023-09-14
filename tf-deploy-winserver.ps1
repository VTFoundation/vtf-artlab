Set-Location $pwd\Terraform

Write-Host "Validating files for syntax errors" -Foreground "Blue"
terraform validate

terraform plan -target="azurerm_windows_virtual_machine.winserver" -target="azurerm_virtual_machine_extension.active_directory_setup" -target="azurerm_dev_test_global_vm_shutdown_schedule.winserver" -out deploy.winserver.tfplan
terraform apply deploy.winserver.tfplan

$vms = $(Get-AzVM -Status)
for ($i = 0; $i -lt $vms.Count; $i++)
{
	if ( $vms.PowerState[$i] -eq "VM running" )
	{
		Write-Host "De-allocating resources for " $vms.Name[$i]
		Stop-AzVM -name $vms.Name[$i] -resourcegroup $vms.ResourceGroupName[$i] -Force
	}
}