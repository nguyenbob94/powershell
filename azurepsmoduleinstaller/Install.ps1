param(
[switch]$Vscode,
[switch]$ProfileInstallOnly,
[switch]$Uninstall
)

function Install-PSProfile
{
  #Get-Credential - Prompts for user input of Azure credentials
  #These credentials will be stored in the $NewCred variable
  $NewCred = Get-Credential -Message "Please enter your Azure admin credentials"

  #Get-Credential - Prompts for user input of Azure credentials
  #These credentials will be stored in the $NewCred variable
  #Export an encrypted credential file onto user's document folder, using the $NewCred variable
  Write-Output "Exporting credentials to an encrypted file and storing as $PWDocuments\Azurecredentials.dat"
  $NewCred | Export-Clixml $PWDocuments\Azurecredentials.dat

   #Create WindowsPowershell profile folder if it doesn't exist
   $ProfileDir = Test-Path -Path $PWDocuments\WindowsPowershell

   if($ProfileDir -eq $True)
   {
     Write-Output "WindowsPowershell folder found."
   }
   else
   {
     mkdir $PWDocuments\WindowsPowershell
   }

   $String = '$PWDocuments = [environment]::getfolderpath("mydocuments")
   . "$PWDocuments\PS-Functions\ConnectTo-Azure.ps1"'
   
  $PSProfilePaths = @("$PWDocuments\WindowsPowershell\Microsoft.PowerShell_Profile.ps1","$PWDocuments\WindowsPowershell\Microsoft.PowerShellISE_Profile.ps1")

  foreach($PSProfilePath in $PSProfilePaths)
  {
    $CheckPSProfile = Test-Path -Path $PSProfilePath

    #If PS profile file exist, append content of $string to existing profile
    if($CheckPSProfile -eq "True")
    {
      Add-Content -Path $PSProfilePath "`n$String"
    }
    else
    {
      New-Item -Path $PSProfilePath -ItemType "File" -Value "`n$String"
      Unblock-File -Path $PSProfilePath
    }
  }

  if($Vscode)
  {
    $CheckPSVSProfile = Test-Path -Path "$PWDocuments\WindowsPowershell\Microsoft.VSCode_profile.ps1"

    if($CheckPSVSProfile -eq $True)
    {
      Add-Content -Path "$PWDocuments\WindowsPowershell\Microsoft.VSCode_profile.ps1" "`n$String"
    }
    else
    {
      New-Item -Path "$PWDocuments\WindowsPowershell\Microsoft.VSCode_profile.ps1" -ItemType "file" -Value "`n$String"
      Unblock-File -Path "$PWDocuments\WindowsPowershell\Microsoft.VSCode_profile.ps1"
    }
  }

  #Install functions in user profile Documents folder
  Write-Output "Creating Powershell function folder: $PWDocuments\PS-Functions"
  Copy-Item .\PS-Functions $PWDocuments -Force -Recurse
  Unblock-File -Path $PWDocuments\PS-Functions\ConnectTo-Azure.ps1
  
  Write-Output ""
  Write-Output ""
  Write-Output "Installing Azure modules for Powershell completed.."
  Write-Output "To initialise connection to the Tenant at anytime, call the cmdlet: ConnectTo-Azure"
  Write-Output ""
}

function Uninstall-Modules
{
  foreach($Module in $ArrayModules)
  {
    $CheckModuleInstalled = Get-InstalledModule -Name $Module -ErrorAction Ignore

    if($CheckModuleInstalled)
    {
      Uninstall-Modules -Name $Module -AllVersions -Force -Verbose
    }
  }
  
  exit
}

#Script entry point
cd $PSScriptRoot
#Universal variable for set Documents folder in your profile. Better to use this if Documents folders are define with custom path or using OneDrive.
$PWDocuments = [environment]::getfolderpath("mydocuments")

#Array of Modules
$ArrayModules = @("ExchangeOnlineManagement","AzureAD","MSOnline","Microsoft.Graph.Intune","Microsoft.Graph","Microsoft.Online.SharePoint.PowerShell","Az")

if($Uninstall -eq $True)
{
  Uninstall-Modules
  Exit
}

if($ProfileInstallOnly)
{
  Install-PSProfile
  exit
} 

Write-Output "Installing the required Powershell Modules"
#Install the required modules
foreach($Module in $ArrayModules)
{
  $CheckModuleInstalled = Get-InstalledModule -Name $Module -ErrorAction Ignore

  if(!$CheckModuleInstalled)
  {
    Install-Module $Module -Scope CurrentUser -Confirm:$false -Allowclobber -Force -Verbose

  }
  elseif($CheckModuleInstalled)
  {
    Write-Output "Please uninstall modules before reinstalling again."
    exit

  }

}

#Install or append Powershell profiles
Install-PSProfile
exit
