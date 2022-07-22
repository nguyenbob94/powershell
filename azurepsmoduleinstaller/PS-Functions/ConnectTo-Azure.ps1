function ConnectTo-Azure
{  
  $PWDocuments = [environment]::getfolderpath("mydocuments")
  $Creds = Import-Clixml "$PWDocuments\Azurecredentials.dat"  

  $CheckCurrentSession = (Get-PSSession).ComputerName
  
  if($CheckCurrentSession -eq $null)
  {
    if(!(Get-Module -ListAvailable -Name "AzureAD")) 
    {
      Install-Module -Name AzureAD -Scope CurrentUser -Force -Verbose 
 
    }

    if(!(Get-Module -ListAvailable -Name "MSOnline")) 
    {
      Install-Module -Name MSOnline -Scope CurrentUser -Force -Verbose 
    
    }

    if(!(Get-Module -ListAvailable -Name "ExchangeOnlineManagement")) 
    {
      Install-Module -Name ExchangeOnlineManagement -Scope CurrentUser -Force -Verbose 
    
    }
	
	if(!(Get-Module -ListAvailable -Name "Microsoft.Online.SharePoint.PowerShell")) 
    {
      Install-Module -Name ExchangeOnlineManagement -Scope CurrentUser -Force -Verbose 
    
    }

    if(!(Get-Module -ListAvailable -Name "Microsoft.Graph.Intune")) 
    {
      Install-Module -Name Microsoft.Graph.Intune -Scope CurrentUser -Force -Verbose -Nocl
 
    }

    if(!(Get-Module -ListAvailable -Name "Microsoft.Graph")) 
    {
      Install-Module -Name MSOnline -Scope CurrentUser -Force -Verbose 
    
    }
    
    if (!(Get-Module -ListAvailable -Name "AZ.Accounts")) 
    {
      Install-Module -Name AZ -Scope CurrentUser -Force -Verbose 
    
    }


    Connect-AzureAD -Credential $Creds
    Connect-MsolService -Credential $Creds
    Connect-ExchangeOnline -Credential $Creds 
    Login-AzAccount -Credential $Creds
    #Connect-SPOService -Url https://mycompanyname-admin.sharepoint.com -Credential $Creds
    Connect-MSGraph 
    Write-Output "For additional commands for Intune and MS Graph. Run the Connect-MgGraph command seperately."
  
  }

}
