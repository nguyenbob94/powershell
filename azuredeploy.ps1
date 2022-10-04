param(
  [string]$rgName = "rg-generic",
  [string]$location = "AustraliaEast",
  [switch]$destroy
)

#Check Azure session
# Check if Azure module is installed on Powershell before running script
$CheckPSModule = (Get-InstalledModule -Name az).Name

if($CheckPSModule -eq "az")
{
  # Check Azure session on Powershell before running script
  $CheckAzSession = Get-AzAccessToken -ErrorAction Ignore

  # If session is available, start deployment. If not, call the Login-AZAccount cmdlet to authenticate with Azure admin account
  if($CheckAzSession)
  {
    Write-Output "Azure session found on Powershell"
    Get-AZAccessToken
  }
  else
  {
    Logout-AZAccount
    Login-AZAccount
  }
}
else
{
  Write-Output "Az Powershell Module is not found, imported or installed. Please install the az Powershell module then run this script again"
  Write-Output "Run the following cmdlet to install: Install-Module -Name az -Scope CurrentUser -AllowClobber"
  exit
}

function Deploy-Resource
{
  #$ProhibitedUsernames = @("Admin","Root")

  #if($username -in $ProhibitedUsernames)
  #{
  #  do
  #  {
  #    $username = Read-Host "Usernames 'admin' and 'root' is not allowed. Please reenter another username"
    
  #  } until($username -notin $ProhibitedUsernames)

  #}
  
  #if(!$password)
  #{
  #  $encryptedPassword = Read-Host "Enter password for VMs" -AsSecureString
  #}
  #else
  #{
    #Convert plain text to encrypted password
  #  $encryptedPassword = $password | ConvertTo-SecureString -AsPlainText -Force
  #}

  New-AzResourceGroup -Name $rgName -Location $location -Force 

  New-AzResourceGroupDeployment `
  -Name "deployment-generic" `
  -ResourceGroupName $rgName `
  -Mode Complete `
  -Verbose `
  -TemplateFile .\main.bicep `
  -Location $location `
  -Force
}

function Remove-Resource
{
  if($RGName -eq "rg-generic")
  {
    Remove-AZResourceGroup -Name $RGName -Force -Verbose
  }
  else
  {
    Write-Output "If a custom RG name was used during the initial deployment of this template, the script will not know which RG to destroy"
    (Get-AZResourceGroup).ResourceGroupName

    try
    {
      $DestroyChoice = Read-Host "Select and type in the RG Group name listed above you wish to destroy"
      Remove-AZResourceGroup -Name $DestroyChoice -Force -Verbose
    }
    catch [System.Exception]
    {
      Write-Host "Invalid Resource Group"
      exit
    }

    Remove-AZResourceGroup -Name $DestroyChoice -Force -Verbose
  }
}

if($destroy)
{
  $CheckRG = Get-AZResourceGRoup -Name $rgName -ErrorAction Ignore

  if(!$CheckRG)
  {
    Write-Output "$rgName does not exist."
    exit
  }

  Remove-Resource
  exit
}

#Check if resource group with exist with the same name in rgName param
$CheckRG = Get-AZResourceGRoup -Name $rgName -ErrorAction Ignore

if(!$CheckRG)
{
  Deploy-Resource
  exit
}
else
{ 
  
  $AcceptedChoiceRG = @("Y","N")

  do
  {
    $Choice = Read-Host "rgName already exists in the Azure environment. Do you want to overwrite it? (Y/N)"

    if($Choice -eq "Y")
    {
      Deploy-Resource
    }
    elseif($Choice -eq "N")
    {
      exit
    }
    else
    {
      Write-Output "Invalid input.."
    }
  } Until($Choice -in $AcceptedChoiceRG)
}

