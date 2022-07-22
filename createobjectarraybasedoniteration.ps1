param(
  [int]$iterationCount,
  [string]$ResourceA = "pubIPName",
  [string]$ResourceB = "nicName",
  [string]$ResourceC = "ifConfigName",
  [string]$ResourceD = "vmName"
)
# What is this?
# This is a script that generates an Azure Bicep array, based on the parameters defined.
# The script will also scrap off commas (,) and all the nasty CRLF in the code that is not visible to the eye.
# By default, I've only made this script to generate an array with 4 properties. These properties to represent Azure resources
# You may add more params if desired. However, note that the extra params will need to be appended as variables on the array at lines 20 and the formatting block of code between lines 32-35

function Aaaaray
{
  $dataArrayObject = @()
  for($i=0; $i -lt $iterationCount; $i++)
  {
    #Change attributes to the properties
    $data = [pscustomobject]@{$ResourceA="pubIP-$i";$ResourceB="nic-$i";$ResourceC="ifconfig-$i";$ResourceD="WIN-$i"}
    $dataArrayObject += $data
  }
  
  # Convert array to json
  $ConvertToJsonArray = $dataArrayObject | ConvertTo-Json
  
  # Modify json format to Azure Bicep format
  $ConvertToJsonArray = [string]::join("",($ConvertToJsonArray.Split(",")))
  $ConvertToJsonArray = [string]::join("'",($ConvertToJsonArray.Split('"')))
  $ConvertToJsonArray = [string]::join("",($ConvertToJsonArray.Split('`r')))
  $ConvertToJsonArray = [string]::join("",($ConvertToJsonArray.Split('`n')))
  
  $Output = $ConvertToJsonArray `
  -replace "'$ResourceA'",$ResourceA `
  -replace "'$ResourceB'",$ResourceB `
  -replace "'$ResourceC'",$ResourceC `
  -replace "'$ResourceD'",$ResourceD `

  $Output | Out-String
}

#Validation of input
if(!$iterationCount)
{
  do
  {
    try
    {
      $iterationCount = Read-Host "Please enter the number of iterations"
    }
    catch [System.Exception]
    {
      Write-Output "Invalid format. A interger is expected"
    }
  } until($iterationCount)
}

Aaaaray
