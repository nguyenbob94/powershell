# envvariableloader-azure
The purpose of this script is to prestore the Azure account information into environment variables so that Terraform can call it when deploying resources. This saves the effort of typing out environment variables each time you open a new CLI session.

## How to use the script

Run the script as per example below. Replace the XXXX values and secret ID with your Azure account details.

#### Example of direct parameter usage
`.\azure-auth-tf.ps1 -ClientID "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -ClientSecret "SOm3RanD0MJ1883r1SH!" -SubscriptionID ""xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -TenantID ""xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"`

Once these environment variables are set, you can then run Terraform to deploy your tf templates.

## Parameters
Parameter      | Detail
-------------  | -------------
ClientID       | Represent the service principal app ID of Terraform on Azure AD 
ClientSecret   | Represent the secret generated key of the service principal app ID of Terraform on Azure AD
SubscriptionID | Represent the subscription ID in Azure where the resources will be deployed to
TenantID       | Represent the Tenant ID of your Azure account (Directory ID)

tl;dr: The script does not run Terraform, it only stores data so that Terraform can be used when run.


#### NOTE TO SELF

Should the IDs and keys are hardcoded into the script, keep the script locally and Do not commit to github by any means, even if the repo is private. The bots out there are vicious at sniffing details. 
