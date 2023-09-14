Set-Location $pwd\Terraform
terraform plan -destroy -out destroy.all.tfplan
terraform apply destroy.all.tfplan