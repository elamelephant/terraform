# This is a base Terraform file to create an Azure App Service in the Azure cloud platform

## Before running Terraform, please follow the instructions below.
## To authenticate the Azure cloud platform to execute Terraform, please follow this command
```hcl
    az login
    az login --service-principal -u "CLIENT_ID" -p "CLIENT_SECRET" --tenant "TENANT_ID"

    Service Principal with Open ID Connect (for use in CI / CD):
    az login --service-principal -u "CLIENT_ID" --tenant "TENANT_ID"

```

> ⚠️ **Note:** “Update the subscription ID in the base/providers.tf file”

## Basic Execution flow
```hcl
    Go to the base folder
    terraform init
    terraform plan
    terraform apply
```

## Important Note
```hcl
    1. GitHub PAT token configured via Azure key vault. This is not the correct way, usually. In the real world, it has to be passed via CI/CD env variable and directly to TF_VAR
    2. All Terraform output variables are not added. Please add to your needs
```


