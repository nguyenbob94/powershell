param(
  [string]$CSVPath,
  [string]$UPN
)

$CheckModules = @((Get-Module -Name AzureAD,MSOnline,ExchangeOnlineManagement).Name)

#Loads AzureAD and Microsoft Exchange PS modules if not already
if(!$CheckModules)
{
   #Preloaded PS function paths for AzureAD and Microsoft Exchange
   $Modulelauncherpath1 = Test-Path -Path "$env:Userprofile\$env:onedrive\Documents\PS-Functions\ConnectTo-365.ps1"
   $Modulelauncherpath2 = Test-Path -Path "$env:Userprofile\Documents\PS-Functions\ConnectTo-365.ps1"

   #Check if PS function path exists before executing ConnectTo-365
   if($Modulelauncherpath1 -eq "true" -or $Modulelauncherpath2 -eq "true")
   {
     Write-Output "Preloaded functions detected. Attempting to load PS Modules for AzureAD, MSOnline and ExchangeOnlineManagement" 

     try
     {
       ConnectTo-365
     }
     catch [Exception]
     {
       Write-Output "Something went wrong. Please ensure the PS Modules and profiles are installed properly before running this script."
       Write-Output ""
       Write-Output "1. Check the path name in your PS Profile is pointing to the correct PS Functions folder path"
       Write-Output "2. Reinstall the AzureAD, MSOnline and ExchangeOnlineManagement from https://github.com/Serraview/PS-ModuleInstaller-o365admin"
       Write-Output "3. Alternatively, Manually load AzureAD, MSOnline and ExchangeOnlineManagement modules using Powershell with elevated rights before running this script."

       exit

     }
   }
   #If the Prefunction folders do not exist. Attempt to load AzureAD and Microsoft Exchange modules manually. User credential input required.
   else
   {
     Write-Output "No preloaded functions detected. Attempting to load PS Modules for AzureAD, MSOnline and ExchangeOnlineManagement"
     try
     {
       Write-Output "Loading Connect-ExchangeOnline"
       Connect-ExchangeOnline
       Write-Output "Loading Connect-AzureAD"
       Connect-AzureAD
       Write-Output "Loading Connect-MsolService"
       Connect-MsolService
     }
     #End script if modules are not installed
     catch [Exception]
     {
       Write-Output "This script cannot be executed since you do not have the following modules"
       Write-Output ""
       Write-Output "AzureAD"
       Write-Output "MSOnline"
       Write-Output "ExchangeOnlineManagement"
       Write-Output ""
       Write-Output "If you have these modules installed but not on a CurrentUser scope. You may need to try running this script in Powershell with elevated rights"
       Write-Output "Alternatively install the modules from https://github.com/Serraview/PS-ModuleInstaller-o365admin"
       exit
    }
  }
}

function Remove-User-Props($UPN)
{
  #Check if user account exists
  try
  {
    $Validate = Get-AzureADUser -objectid $UPN
  } 
  catch [Exception]
  {
    Write-Output "User $UPN is not found in AAD.. Skipping"
    return
  }
  
  $properties = [Collections.Generic.Dictionary[[String],[String]]]::new()
  $properties.Add("JobTitle", [NullString]::Value)
  $properties.Add("Department", [NullString]::Value)
  $properties.Add("PhysicalDeliveryOfficeName", [NullString]::Value)

  Set-AzureADUser -objectid $UPN -ExtensionProperty $properties
  Remove-AzureADUserManager -ObjectId $UPN
  
}

if($CSVPath -and $UPN)
{
  Write-Output "Only 1 method of import can be used"
  exit
}

if($UPN)
{
  Remove-User-Props $UPN
}
elseif($CSVPath)
{
  $Import = Import-CSV -Path $CSVPath

  foreach($User in $Import)
  {
    $UPN = $User.UPN
    Remove-User-Props $UPN
  }
}