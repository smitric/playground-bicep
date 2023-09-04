Function SendEmailToUser {
    Param(
        [Parameter(Mandatory = $true)] [string]$email,
        [Parameter(Mandatory = $true)] [String]$resourceGroupName,
        [Parameter(Mandatory = $true)] [String]$displayName
    )

    # Create the email message
    $Subject = "Azure Playground: Resource Group created"
    $Body = "
            Hi $displayName,

            Your Resource Group ($resourceGroupName) has been created!
            The Resource Group and all the resources in it will be automatically deleted after 30 days and/or if your cost will rise above €150,-

            Enjoy and have fun!

            Azure Playground Team


            This is an automatically generated email. If you have any questions or recommendations you can reply to this mail.
            "


    # Send the email message
    $SMTP = "smtp.gmail.com"
    $From = "dutchazureplayground@devoteam.com"
    $SMTPClient = New-Object Net.Mail.SmtpClient($SMTP, 587)
    $SMTPClient.EnableSsl = $true                  
    $secret = (Get-AzKeyVaultSecret -vaultName "kv-pers-admin" -name "gmail-smtp" -AsPlainText)
    [SecureString]$securepassword = $secret | ConvertTo-SecureString -AsPlainText -Force 
    $SMTPClient.Credentials = New-Object System.Net.NetworkCredential($From, $securepassword)
    $SMTPClient.Send($From, $email , $Subject, $Body)
}