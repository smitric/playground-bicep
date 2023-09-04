$mail = ""
$pillar = ""
$usage = ""


# Get user details based on email
$jsonObj = az ad user list  --query "[?mail=='$mail'].{objectId:objectId,fullName:displayName}" -o json | ConvertFrom-Json
$displayName = $jsonObj[0].fullName
$objectId = $jsonObj[0].objectId
$fullName = $jsonObj[0].fullName.trim().replace(" ","_").toLower()
write-host "Display name in Azure AD: $displayName"


$resourceGroupName = ("pers-"+$fullName+"-rg").Replace(" ","_")

#  Create RG
Write-host "Resourcegroup name: $resourceGroupName"
az deployment sub create `
    --name createRg `
    --location westeurope `
    --parameters `
        resourceGroupName=$resourceGroupName `
        resourceGroupLocation=westeurope `
        pillar=$pillar `
        usage=$usage `
    --template-file RG.bicep


# Assign owner
az role assignment create `
    --role "Owner" `
    --assignee-object-id "$objectId" `
    --scope "/subscriptions/41e50375-b926-4bc4-9045-348f359cf721/resourceGroups/$resourceGroupName"
