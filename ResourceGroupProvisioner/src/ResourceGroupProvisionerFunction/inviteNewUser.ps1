function InviteUser {
    param(
        [Parameter (Mandatory = $true)] [String]$userEmail,
        [Parameter (Mandatory = $true)] [String]$userName
    )

    $domain = $userEmail.Split("@")[1]

    if ($domain -ne "devoteam.com") {
        Write-Warning "Email: '$userEmail' is invalid."
        exit 1
    }
    
    $tokenResponse = Get-AzAccessToken -ResourceTypeName MSGraph
    $token = $tokenResponse.Token
    
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Authorization", "Bearer $token")
    $headers.Add("Content-Type", "application/json")
    
    $tenantName = "DevoteamNL"

    $body = "{
    `n    `"SendInvitationMessage`"   : true,
    `n    `"InvitedUserDisplayName`" : `"$userName`",
    `n    `"InvitedUserEmailAddress`" : `"$userEmail`",
    `n    `"InviteRedirectUrl`"       : `"https://portal.azure.com/@$tenantName.onmicrosoft.com`",
    `n}"
    
    Try {
        $response = Invoke-RestMethod "https://graph.microsoft.com/v1.0/invitations" -Method "POST" -Headers $headers -Body $body
    }
    Catch {
        Write-Error $_
        exit 1
    }
    
    $userId = $response.invitedUser.id
    
    Write-host "Invite for '$userName ($userEmail)' was sent. User id: $userId"

    return $userId
}