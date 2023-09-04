. "$PSScriptRoot\sendMessageToGoogleChat.ps1"

Function SendMessageToGoogleChat {
    Param(
        [Parameter(Mandatory = $true)] [String]$requestorEmail,
        [Parameter(Mandatory = $true)] [String]$errorMessage,
        [Parameter(Mandatory = $true)] [String]$invocationId
    )

    $urlToExecutionLogs = 
        "https://portal.azure.com/#view/Microsoft_OperationsManagementSuite_Workspace/Logs.ReactView/resourceId/" +
        "%2Fsubscriptions%2F08366944-ec2c-43de-b490-2531c98b9d08%2FresourceGroups%2Fpers-admin-rg%2Fproviders%2Fmicrosoft.insights%2Fcomponents%2Fresource-group-provisioner/" +
        "source/Microsoft.Web-FunctionApp/query/union%20traces%7C%20union%20exceptions%7C%20where%20timestamp%20%3E%20ago(30d)%7C%20where%20customDimensions%5B'" +
        "InvocationId'%5D%20%3D%3D%20'$invocationId'%7C%20order%20by%20timestamp%20asc%7C%20project%20timestamp%2C%20message%20%3D%20iff" +
        "(message%20!%3D%20''%2C%20message%2C%20iff(innermostMessage%20!%3D%20''%2C%20innermostMessage%2C%20" +
        "customDimensions.%5B'prop__%7BOriginalFormat%7D'%5D))%2C%20logLevel%20%3D%20customDimensions.%5B'LogLevel'%5D"

    $message = "An error was found in the provisioning process for *$requestorEmail*.

*Exception message*:
$errorMessage

*You can see the execution logs here*: 
$urlToExecutionLogs"

    SendMessageWebhook -Message $message

    Write-Host "An error message was sent to PlayGround Google Chat Space"
}
