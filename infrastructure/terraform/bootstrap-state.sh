# Terraform state backend bootstrap
#
# Run this ONCE before `terraform init` to create the remote state storage.
# Requires Azure CLI logged in: `az login`
#
# Usage:
#   chmod +x bootstrap-state.sh
#   ./bootstrap-state.sh

set -euo pipefail

LOCATION="australiaeast"
RG="rg-volentry-tfstate"
STORAGE_ACCOUNT="stvolentrystate"
CONTAINER="tfstate"

echo "Creating resource group: $RG"
az group create --name "$RG" --location "$LOCATION"

echo "Creating storage account: $STORAGE_ACCOUNT"
az storage account create \
  --name "$STORAGE_ACCOUNT" \
  --resource-group "$RG" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --kind StorageV2 \
  --allow-blob-public-access false

echo "Creating blob container: $CONTAINER"
az storage container create \
  --name "$CONTAINER" \
  --account-name "$STORAGE_ACCOUNT"

echo ""
echo "Done. Now run:"
echo "  cd infrastructure/terraform"
echo "  terraform init"
