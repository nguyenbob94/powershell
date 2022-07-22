#Change the default values to match your Azure details. These can also be overwritten directly when passing through params while executing the script
param(
[string]$ClientID = "",
[string]$ClientSecret = "",
[string]$SubscriptionID = "",
[string]$TenantID = ""
)

$env:ARM_CLIENT_ID=$ClientID
$env:ARM_CLIENT_SECRET=$ClientSecret
$env:ARM_SUBSCRIPTION_ID=$SubscriptionID
$env:ARM_TENANT_ID=$TenantID
