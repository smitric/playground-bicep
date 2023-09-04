
# Input bindings are passed in via param block.
param([byte[]] $InputBlob, $TriggerMetadata)

. "$PSScriptRoot\getUserName.ps1"
. "$PSScriptRoot\createResourceGroupAndDependencies.ps1"

$invocationId =  $TriggerMetadata.InvocationId

$requests = [System.Text.Encoding]::ASCII.GetString($InputBlob) | ConvertFrom-Json

foreach ($request in $requests) {
    $requestTimestamp = $request.Timestamp
    $date = [datetime]::parseexact($requestTimestamp, 'dd/MM/yyyy HH:mm:ss', $null).Date
    $email = $request.Email_x0020_address
    $userName = GetUserName -Email $request.Email_x0020_address
    $userRole = $request.I_x0020_have_x0020_the_x0020_role_x0020_of

    $pillar = $request.Please_x0020_pick_x0020_your_x0020_pillar
    $pillar = ($pillar -ne "") ? $pillar : $request."Please_x0020_pick_x0020_your_x0020_pillar_x0020_(1)"
    
    $usage = $request.What_x0020_will_x0020_be_x0020_your_x0020_primary_x0020_usage_x0020_on_x0020_Azure_x003f_
    $usage = ($usage -ne "")   ? $usage  : "Training / Certification related activities"


    $cutoffInDays = 1
    $cutoffDate = (get-date).AddDays($cutoffInDays * -1).Date

    if ($date -ge $cutoffDate) {
        Write-Host "Processing: $requestTimestamp -Email $email -UserName $userName -Pillar $pillar -Usage $usage -UserRole $userRole"
        CreateResourceGroupAndDependencies -Email $email -UserName $userName -Pillar $pillar -Usage $usage -UserRole $userRole -InvocationId $invocationId
    }
    else {
        Write-Host "Not processed. Reason: request date => $requestTimestamp -Email $email -UserName $userName -Pillar $pillar -Usage $usage -UserRole $userRole"
    }
}

Write-Host "PowerShell Blob trigger function Processed blob! Name: $($TriggerMetadata.Name) Size: $($InputBlob.Length) bytes"
