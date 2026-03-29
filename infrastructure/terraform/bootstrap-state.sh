# Terraform state backend bootstrap
#
# Run this ONCE before `terraform init` to create the remote state storage.
# Requires Azure CLI logged in: `az login`
#
# Usage:
#   chmod +x bootstrap-state.sh
#   ./bootstrap-state.sh [suffix]
#
# The optional suffix (e.g. your initials or a short random string) ensures the
# storage account name is globally unique. If omitted, a random 4-char suffix is generated.
#
# Example:
#   ./bootstrap-state.sh ab42

set -euo pipefail

LOCATION="australiaeast"
RG="rg-volentry-tfstate"
CONTAINER="tfstate"

SUFFIX="${1:-$(cat /dev/urandom | LC_ALL=C tr -dc 'a-z0-9' | head -c 4)}"
STORAGE_ACCOUNT="stvolentry${SUFFIX}"

echo "Using storage account: $STORAGE_ACCOUNT"

echo "Creating resource group: $RG"
az group create --name "$RG" --location "$LOCATION"

echo "Creating storage account: $STORAGE_ACCOUNT"
az storage account create \
  --name "$STORAGE_ACCOUNT" \
  --resource-group "$RG" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --kind StorageV2 \
  --allow-blob-public-access false \
  --min-tls-version TLS1_2

echo "Enabling blob versioning and soft delete"
az storage account blob-service-properties update \
  --account-name "$STORAGE_ACCOUNT" \
  --resource-group "$RG" \
  --enable-versioning true \
  --delete-retention-days 30

echo "Creating blob container: $CONTAINER"
az storage container create \
  --name "$CONTAINER" \
  --account-name "$STORAGE_ACCOUNT"

echo ""
echo "Done. Update versions.tf backend with:"
echo "  storage_account_name = \"$STORAGE_ACCOUNT\""
echo ""
echo "Then initialise per environment, e.g.:"
echo "  terraform init -backend-config=\"key=volentry-dev.tfstate\""
