function GetUserName {
    param(
        [Parameter (Mandatory = $true)] [String]$email
    )
    $nameParts = $email.Split("@")[0].Split(".")

    $name = ""
    foreach ($namePart in $nameParts) {
        $name += $namePart.SubString(0, 1).ToUpper() + $namePart.SubString(1) + " "
    }
    return $name.Trim()
}