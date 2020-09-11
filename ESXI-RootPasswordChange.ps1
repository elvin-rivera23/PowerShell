<## 
	FOR GITHUB PURPOSES I'M REMOVING ANY SENSITIVE FILE NAMES OR LOCATION NAMES
	I have the working script, but in this case I will use ** on sensitive areas
 ##>



Set-ExecutionPolicy -ExecutionPolicy Unrestricted

Find-Module -Name VMware.PowerCLI
Install-Module -Name VMware.PowerCLI -Scope CurrentUser
Get-Command -Module *VMWare*

Connect-VIServer -Server CA-**-VCen**.CollegeDomain.edu

try{

    $cred = Get-Credential -UserName "root" -message "Enter new ESXi root password"
    $vmhosts = get-vmhost | Out-GridView -PassThru -Title "Select ESXi hosts for changing the root password"
    Foreach ($vmhost in $vmhosts) {
        $esxcli = get-esxcli -vmhost $vmhost -v2 
        $esxcli.system.account.set.Invoke(@{id=$cred.UserName;password=$cred.GetNetworkCredential().Password;passwordconfirmation=$cred.GetNetworkCredential().Password})
        $esxcli.system.
    }

}

catch{
    
    Write-Host "Error Occurred"  -ForegroundColor Red
    Write-Host $_
    
} 
