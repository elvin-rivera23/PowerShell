<## 
	FOR GITHUB PURPOSES I'M REMOVING ANY SENSITIVE FILE NAMES OR LOCATION NAMES
	I have the working script, but in this case I will use ** on sensitive areas
 ##>





#############################################################################################################################
# Checks the health of the CollegeName DCs
# v1.0
# Written By: Elvin Rivera
# Date: 1/21/20
#
# Desc: This script will gather all the DCs in our CollegeName Domain and check the health by running the function DCdiag.
#       The user running this script must have permission levels of a Domain Administrator.
#
#############################################################################################################################

function Invoke-DcDiag {
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$DomainController
    )
 try{

    $result = dcdiag /s:$DomainController
    $result | select-string -pattern '\. (.*) \b(passed|failed)\b test (.*)' | foreach {
        $obj = @{
            TestName = $_.Matches.Groups[3].Value
            TestResult = $_.Matches.Groups[2].Value
            Entity = $_.Matches.Groups[1].Value
        }
        [pscustomobject]$obj
    }
}
catch{
        Write-Host "An error occurred:" -ForegroundColor Red
        Write-Host $_ -ForegroundColor Yellow
        Write-Host $_.ScriptStackTrace
    }
}

$timeStamp = Get-Date -f MM-dd-yyy-h-m-s
    
$Path = "~\desktop\CollegeName-DC-Health-" + $timestamp + ".csv"

$DCs = Get-ADDomainController -Server CLC-**1 -Filter *

foreach($DC in $DCs){

    Write-Host "################## " $DC.name  " Begin ##################" -ForegroundColor DarkGreen

    $DCHealth = Invoke-DcDiag -DomainController $DC.name | Export-csv -Path $Path -NoTypeInformation -Append

    Write-Host "################## " $DC.name  " End ##################" -ForegroundColor Green

}
