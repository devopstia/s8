# Get the root directory of the repository
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

if [ -z "$REPO_ROOT" ]; then
    echo "Not a git repository or unable to determine repository root."
    exit 1
fi

# Delete terraform directories and files
find "./terraform/modules" -type d -name '.terraform' -exec rm -rf {} \;
find "./terraform/modules" -type f -name 'terraform.tfstate' -exec rm -f {} \;
find "./terraform/modules" -type f -name 'terraform.tfstate.backup' -exec rm -f {} \;

find "./terraform/resources" -type d -name '.terraform' -exec rm -rf {} \;
find "./terraform/resources" -type f -name 'terraform.tfstate' -exec rm -f {} \;
find "./terraform/resources" -type f -name 'terraform.tfstate.backup' -exec rm -f {} \;

find "./terraform/terraform-concepts" -type d -name '.terraform' -exec rm -rf {} \;
find "./terraform/terraform-concepts" -type f -name 'terraform.tfstate' -exec rm -f {} \;
find "./terraform/terraform-concepts" -type f -name 'terraform.tfstate.backup' -exec rm -f {} \;

echo "Cleanup complete."