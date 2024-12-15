# Get the root directory of the repository
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

cd $REPO_ROOT
cd terraform/resources/dev/vpc
terraform init 
terraform fmt
terraform plan

cd $REPO_ROOT
cd terraform/resources/dev/bastion-host
terraform init 
terraform fmt
terraform plan

cd $REPO_ROOT
cd terraform/resources/dev/aws-secret-manager
terraform init 
terraform fmt
terraform plan