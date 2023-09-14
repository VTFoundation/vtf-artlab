Set-Location $pwd\Terraform

terraform init -upgrade

Write-Host "Validating files for syntax errors" -Foreground "Blue"
terraform validate

terraform plan -out deploy.all.tfplan
terraform apply deploy.all.tfplan

Write-Host "Output" -Foreground "Blue"
terraform output -json | Out-File -FilePath "output.txt"
Write-Host "saved to Terraform\output.txt" -Foreground "Green"
Write-Host "WARNING: FOR SECURITY, PLEASE DELETE THIS FILE AFTER SAVING OUTPUT (i.e. credentials, SSH keys) TO A SECURE PLACE (i.e. Password manager)" -Foreground "Red"

Write-Host "Generating VPN client configuration files" -Foreground "Blue"
$profile=New-AzVpnClientConfiguration -ResourceGroupName "RTLAB" -Name "RTLAB-vpn" -AuthenticationMethod "EapTls"
$profile.VPNProfileSASUrl

Write-Host "Stopping all running VMs" -Foreground "Blue"
$vms = $(Get-AzVM -Status)
for ($i = 0; $i -lt $vms.Count; $i++)
{
	if ( $vms.PowerState[$i] -eq "VM running" )
	{
		Write-Host "De-allocating resources for " $vms.Name[$i]
		Stop-AzVM -name $vms.Name[$i] -resourcegroup $vms.ResourceGroupName[$i] -Force
	}
}