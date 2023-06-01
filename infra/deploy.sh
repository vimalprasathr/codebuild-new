mv backend.tf-dev backend.tf
mv dev.tfvars terraform.tfvars
cat terraform.tfvars
mv vpc.tf-dev vpc.tf
terraform init
terraform plan
