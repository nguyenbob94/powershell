#This script only works in administrator mode
#If variable is true, the script is run without admin
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$IsAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

function Config-AdminStuff
{
  # Skype is awful
  Get-AppxPackage -allusers Microsoft.SkypeApp | Remove-AppxPackage

  # Download and install chocolatey
  Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

  # Install chocolatey apps. Change if necessary
  choco install adobereader -y
  choco install winrar -y
  choco install git -y
  choco install foobar2000 -y
  choco install hwmonitor -y 
  choco install notepadplusplus -y
  choco install bicep -y
  choco install vlc -y
  choco install vscode -y

  #Create bin folder on C:
  $LocalBinFolder = (New-Item -Path $env:USERPROFILE -ItemType Directory -Name "bin").Name

}

function Config-CurrentUser
{
  #Set power config
  cmd.exe /c "powercfg -change -monitor-timeout-ac 30"
  cmd.exe /c "powercfg -change -standby-timeout-ac 0"
  cmd.exe /c "powercfg -change -hibernate-timeout-ac 0"

  #Explorer config
  $ExplorerRPath = "Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
    Set-ItemProperty -Path "$ExplorerRPath\Ribbon" -Name "MinimizedStateTabletModeOff" -Value 0 # Ribbon expand
    Set-ItemProperty -Path "$ExplorerRPath\Advanced" -Name "HideFileExt" -Value 0 # Show file extentions
    Set-ItemProperty -Path "$ExplorerRPath\Advanced" -Name "HideIcons" -Value 0 # Show hidden icons

  #Add user profile folder to Quick access
  $QuickAccess = New-Object -com shell.application
  $QuickAccess.Namespace($env:userprofile).Self.InvokeVerb("pintohome")

  #Dark theme
  $ThemesRPath = "Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes"
    Set-ItemProperty -Path "$ThemesRPath\Personalize" -Name "AppsUseLightTheme" -Value 0
    Set-ItemProperty -Path "$ThemesRPath\Personalize" -Name "SystemUseLightTheme" -Value 0

  #Taskbar
  $TaskbarRPath = "Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion"
    Set-ItemProperty -Path "$TaskbarRPath\Search" -Name "SearchBoxTaskbarMode" -Value 0
    Set-ItemProperty -Path "$TaskbarRPath\Feeds" -Name "ShellFeedsTaskbarViewMode" -Value 0
}

if($IsAdmin -eq $true)
{
  Write-Output "Script running as administrator. Commencing modifications requiring administrative rights"
  Config-AdminStuff
  Config-CurrentUser
  exit
}
elseif($IsAdmin -eq $false)
{
  Write-Output "This script is required to be run as Administrator"
  exit
}




