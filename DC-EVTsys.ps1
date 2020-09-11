<## 
	FOR GITHUB PURPOSES I'M REMOVING ANY SENSITIVE FILE NAMES OR LOCATION NAMES
	I have the working script, but in this case I will use ** on sensitive areas
 ##>




Set-ExecutionPolicy Unrestricted

try
{

$DCs = Get-ADDomainController -Server CLC-**1.domain.edu -Filter *

##$DC = Get-ADDomainController -Server CLC-**1.domain.edu -Filter {HostName -eq "MA-**1.College.domain"}

$Credential = Get-Credential

foreach($DC in $DCs){

    Write-Host "################## " $DC.Name  " Begin ##################" -ForegroundColor DarkGreen

    $Status = Test-Connection -ComputerName $DC.Name -Quiet

    If($Status -eq $False) {
        
        Write-Host $DC.Name + " is offline. Continueing to next DC." -ForegroundColor Yellow
        Continue 
    }

    $NewSession = New-PSSession -ComputerName $DC.Name -Credential $Credential -ErrorAction Continue

    Enter-PSSession -Session $NewSession -ErrorAction Continue

    $destinationFile = "\\" + $DC.Name + "\C$\Windows\System32\evtsys.exe"

    $TestPath = Test-Path $destinationFile

    if ($TestPath -eq $False)
    {
        Write-Host "Copying EVTSYS.exe to DC" -ForegroundColor Yellow

        $Copydestination = "\\" + $DC.Name + "\C$\Windows\System32"

        Robocopy.exe \\College.domain\NetLogon $Copydestination evtsys.exe /ZB
    }

        Start-Process evtsys.exe -ArgumentList {-i -h 172.0.0.0}   #172.**.**.**

        Restart-Service -Name evtsys 

    Exit-PSSession 

    Remove-PSSession $NewSession

    Write-Host "################## " $DC.name  " End ##################" -ForegroundColor Green

}

Write-Host "################ COMPLETE ################" -ForegroundColor Cyan

}

## Catches any errors
Catch 
{ 
    Write-Error $_ 

    $ErrorMessage = $_

    $DC.Name | Export-csv -Path "~\desktop\DC-Fail-List.csv" -NoTypeInformation -Append 

    $ErrorMessage | Export-csv -Path "~\desktop\DC-Fail-List.csv" -NoTypeInformation -Append 
    
}

