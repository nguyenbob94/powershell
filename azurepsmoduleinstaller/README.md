# azurepsmoduleinstaller by Bob Nguyen

# Prerequesites

Before running any Powershell scripts in general, make sure you have set your global ExecutionPolicy to enable scripts to be run your system. This can be acheived by opening Powershell as Administrator and running the following `Set-ExecutionPolicy -ExecutionPolicy Unrestricted`

This only needs to be done once. If you have already done this, then your prerequesites is satisfied.

# Summary

When Windows Powershell is run by default, Microsoft 365 and Azure powershell cmdlets are not available as its modules are not available out of the box. Traditionally, these module(s) are installed individually per component using the Install-Module cmdlet, and they include:
- Azure AD v1 (MSOnline)
- Azure AD v2 (AzureAD)
- Microsoft Exchange (ExchangeOnlineManagement
- Intune (Microsoft.Graph.Intune)
- Azure (AZ)


This repo provides a script to install all of the modules required, as well as a custom cmdlet to be able to authenticate all of the modules with just one command - `ConnectTo-Azure`

# Script Description

### Install.ps1

Running `Install.ps1` automates the process of downloading and installing the modules from above, required to run AzureAD, Exchange Online and Intune cmdlets to manage Azure using Powershell. 

In addition, the installer will ask for you Azure admin credentials. Once entered, your credentials will be stored in a variable and append to a `.dat` file in your Documents folder. Powershell will use this `.dat` each time you authenticate to MS via a new Powershell session without having the need to enter your credentials each time.

### UpdateCredFile.ps1

If you have recently changed your Azure admin password. Update your cached credential .dat file by running  the `UpdateCredFile.ps1` script.

# How to Install

First, make sure you have meet the prequesites from above. Otherwise, running any PS scripts will be deemed useless. 

1. Clone this whole repo then access the whole folder. Do not move any of the files and folders in the cloned repo.
2. Run the `install.ps1` script and follow the prompts to install the modules (No administrator rights needed). 
3. After all the modules are installed, the script will prompt for your M365 admin credentials.
4. After the installation is complete, close Powershell and reopen it. To authenticate to Microsoft 365 at anytime, run the `ConnectTo-Azure` cmdlet.

### Install behaviour
During the script execution, the M365 modules will be installed on a `CurrentUser` scope as opposed to the system default. This elminiates the need run Powershell as Administrator when installing as well as loading the modules in the future.

Additionally, the script will automatically detect where it is whether if your Documents folder is synced via OneDrive or stored locally and created the required files and folders in them. However, they must be either in the following paths for the script to work
- `C:\Users\YourName\OneDrive - MyCompanyName\Documents`
- `C:\Users\YourName\Documents`

To confirm if your Documents path is correctly configured. Run the following Powershell command to check: `[environment]::getfolderpath("mydocuments")`

# How to access Microsoft 365 through Powershell

Simply open up Powershell as a normal user and run `ConnectTo-Azure`

The rest is all magic.

# Bottom Line
Stop spending more time hating yourself when administering Microsoft 365 on the web UI. Instead, be more productive and use Powershell to manage Azure AD, Intune and Microsoft Exchange effectively.

Lets face it. The web UI is slow and sluggish and at times, doing basic tasks such as a creating or modifying a user account or groups can take forever as you have to wait for the webpage to load.


