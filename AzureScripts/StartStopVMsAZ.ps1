# Created by: Elvin Rivera
# Date Created: 11/22/2020
# Stop and start Azure Virtual Machines in Powershell

Param(
 [string]$VmName,
 [string]$ResourceGroupName,
 [ValidateSet("Startup", "Shutdown")]
 [string]$VmAction
)
 
# Login to Automation Account
$Conn = Get-AutomationConnection -Name AzureRunAsConnection
Add-AzureRMAccount -ServicePrincipal -Tenant $Conn.TenantID `
-ApplicationID $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint | Out-Null
 
# Startup Virtual Machines for example, VM01,VM02,VM03 etc
$vms = $VmName.split(',')
foreach($vm in $vms) {
IF ($VmAction -eq "Startup") {
    Start-AzureRmVM -Name $Vm -ResourceGroupName $ResourceGroupName | Out-Null
    #Write-Output "VM $Vm in Resource Group $ResourceGroupName was started Successfully" 
    $objOut = [PSCustomObject]@{
    ResourceGroupName = $ResourceGroupName
    VMName = $Vm
    VMAction = $VmAction
    }
    Write-Output ( $objOut | ConvertTo-Json)
    }
}

# Shutdown Virtual Machines for example, VM01,VM02,VM03 etc
$vms = $VmName.split(',')
foreach($vm in $vms) {
IF ($VmAction -eq "Shutdown") {
    Stop-AzureRmVM -Name $Vm -ResourceGroupName $ResourceGroupName -Force | Out-Null
    #Write-Output "VM $Vm in Resource Group $ResourceGroupName was stopped Successfully"
    $objOut = [PSCustomObject]@{
    ResourceGroupName = $ResourceGroupName
    VMName = $Vm
    VMAction = $VmAction
    }
    Write-Output ( $objOut | ConvertTo-Json)
    }
}