param($rg_name)

Write-Host "Checking RG existence: $rg_name"
if (Get-AzResourceGroup -Name $rg_name -ErrorAction SilentlyContinue){
  try {
    Write-Host "Removing RG: $rg_name"
    Remove-AzResourceGroup -Force -Name $rg_name -ErrorAction Stop -Verbose
    Write-Host "RG removed"
  }
  catch {
    Write-Error "Can't remove RG: $_"
  }
}
else {
  write-warning "RG not found: $rg_name"
}
