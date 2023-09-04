Function Add-Workitem {

	param (
		[Parameter(Mandatory = $true)]
		[String]
		$name,

		[Parameter(Mandatory = $true)]
		[String]
		$email,

		[Parameter(Mandatory = $true)]
		[String]
		[ValidateSet('Consultant', 'Future')]
		$role,

		[Parameter(Mandatory = $false)]
		[String]
		[ValidateSet('Innovative Tech', 'M-Cloud','S-Platform', 'Public', 'Digital Impulse')]
		$pillar,

		[Parameter(Mandatory = $false)]
		[String]
		[ValidateSet('DevOps', 'Integration', 'DaaS', 'Software Engineering')]
		$futureTrack,

		[Parameter(Mandatory = $false)]
		[String]
		$futureStartingDate,

		[Parameter(Mandatory = $true)]
		[String]
		$primaryUsage,

		[Parameter(Mandatory = $false)]
		[String]
		$extendedUsage,

		[Parameter(Mandatory = $false)]
		[String]
		$dateRequested,
	
		# Provide your Azure DevOps personal access token
		[Parameter(Mandatory = $true)]
		[String]
		$azDevOpsPAT
	)

	$title = "Create RG for ${name}"

	$ADOAuthHeader = @{
		Authorization = 'Basic ' +
		[Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($azDevOpsPAT)"))
	}

	$organization = "DevoteamNLPlayground"
	$UriOrganization = "https://dev.azure.com/$($organization)/"

	$type = "User Story"
	$project = "Azure Playground"

	$uri = $UriOrganization + $project + "/_apis/wit/workitems/$" + $type + "?api-version=7.1-preview.3"
	write-host $uri

	$description = "Requesting resource group: <br />"
	$description += "<br />"
	$description += "<b>Email:</b> ${email}<br />"
	$description += "<b>Timestamp of request:</b> ${dateRequested}<br />"
	$description += "<b>Role:</b> ${role}<br />"
	$description += "<b>Future Track:</b> ${futureTrack}<br />"
	$description += "<b>Pillar:</b> ${pillar}<br />"
	$description += "<b>Primary usage:</b> ${primaryUsage}<br />"
	$description += "<b>Extended usage?: </b>${extendedUsage} <br />"
	$description += "<b>Usage Explanation: </b>${usageExplanation}"

	$body = "[
		{
			`"op`" : `"add`",
			`"path`" : `"/fields/System.Title`",
			`"value`" : `"${title}`"
		},
		{
			`"op`" : `"add`",
			`"path`" : `"/fields/System.Description`",
			`"value`" : `"${description}`"
		}
	]"

	invoke-restmethod -Uri $uri -Method POST -Headers $ADOAuthHeader -ContentType "application/json-patch+json" -Body $body

}

# Execute the function
Add-Workitem


