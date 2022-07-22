#Get-Credential - Prompts for user input of Azure credentials
#These credentials will be stored in the $NewCred variable
$NewCred = Get-Credential -Message "Please enter your Azure admin credentials"

$PWDocuments = [environment]::getfolderpath("mydocuments")

#Export an encrypted credential file onto user's document folder, using the $NewCred variable
Write-Output "Updating credentials to an encrypted file and storing as $PWDocuments\Azurecredentials.dat"
Write-Output "Done"
Write-Output ""
$NewCred | Export-Clixml $PWDocuments\Azurecredentials.dat
