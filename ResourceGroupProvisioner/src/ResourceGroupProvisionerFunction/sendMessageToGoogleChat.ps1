Function SendMessageWebhook {
    Param(
        [Parameter(Mandatory = $true)] [string]$message
    )

    $headers = @{
        'Content-Type' =  'application/json; charset=UTF-8'
    }

    $body = @{ text = $message }

    $url = (Get-AzKeyVaultSecret -vaultName "kv-pers-admin" -name "playground-azure-automation-webhook" -AsPlainText)

    $request = @{
        Uri     = $url
        Method  = 'POST'
        Headers = $headers
        Body    = ConvertTo-Json($body)
    }

    Invoke-WebRequest @request | Out-Null
}
