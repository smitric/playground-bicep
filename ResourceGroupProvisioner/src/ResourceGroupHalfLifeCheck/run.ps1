param($Timer)

Write-Host "PowerShell time trigger function ran! TIME: $currenUTCtime"

$subscriptionId = (Get-AzContext).Subscription.id
$path = "/subscriptions/$subscriptionId/resourceGroups?api-version=2020-06-01&%24expand=createdTime"
$response = Invoke-AzRestMethod -Path $path
$json = $response.Content | ConvertFrom-Json
$personal = $json.Value | Where-Object { $_.name.endswith("-rg")}

$cutoffDate = (get-date).AddDays(-15).Date
$cutOffDatePlusOne = (get-date).AddDays(-16).Date
$toNotify = $personal | Where-Object { (get-date $_.createdTime) -lt $cutoffDate}

$SMTP = "smtp.gmail.com"                         
$From = "dutchazureplayground@devoteam.com"
$Email = New-Object Net.Mail.SmtpClient($SMTP, 587)
$Email.EnableSsl = $true                  
$secret = (Get-AzKeyVaultSecret -vaultName "kv-pers-admin" -name "gmail-smtp" -AsPlainText)
[SecureString]$securepassword = $secret | ConvertTo-SecureString -AsPlainText -Force 
$Email.Credentials = New-Object System.Net.NetworkCredential($From, $securepassword)

$subject = "Notification: Resource Group"
$contentBody = 
" This is an automatically generated email. If you have any questions or recommendations you can reply to this mail.           
You are being notified because your RG '$rgName' is already 15 days old. 
Your RG will be removed after ' $deleteDate'." 
    
foreach ($rg in $toNotify) {
    $rgName = $rg.name
    $userRole = $rg.tags.role
    $createdTime = $rg.createdTime
    $deleteDate = $rg.createdTime.AddDays(30)
    $rgOwner = Get-AzRoleAssignment | Where-Object {$_.Scope -eq "/subscriptions/$subscriptionId/resourceGroups/$rgName" }
    $ownerId = $rgOwner[0].ObjectId
    $emailOwner = Get-AzADUser -objectid $ownerId | Select-Object mail

    Write-Host "####################################### $rgName ####################################"
    if ($userRole -eq "Futures") {
        Write-Host "The role of the Resource group '$rgName' owner is a $userRole. No email will be send to Futures"
        Write-Host  "Created time: $createdTime #### cut off date: $cutoffDate ## cut off date plus one day: $cutoffdateplusOne"
    } 
    elseif ($createdTime -lt $cutoffDate -And $createdTime -gt $cutoffdateplusOne) {
        Write-Host "The owner of resource group '$rgName' will be notified by email"
        Write-Host  "Created time: $createdTime #### cut off date: $cutoffDate ## cut off date plus one day: $cutoffdateplusOne"
        #$Email.Send($From, $emailOwner, $Subject, $contentBody)  
    }
    else {
        Write-Host "No email will be send. Reasons 1) RG not between 15-16 days old 2) no owner id found 3) wrong owner object id"
        Write-Host  "Created time: $createdTime #### cut off date: $cutoffDate ## cut off date plus one day: $cutoffdateplusOne"
    }
    Write-Host "####################################### $rgName ####################################"
}
