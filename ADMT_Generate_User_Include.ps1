<## 
	FOR GITHUB PURPOSES I'M REMOVING ANY SENSITIVE FILE NAMES OR LOCATION NAMES
	I have the working script, but in this case I will use ** on sensitive areas
 ##>




<#
    Generate College User Include File
    Elvin Rivera
    

    Grab users in the defined OU, and create the include .csv file to help during the ADMT process.
    * If user objects live in multiple OUs, run this multiple times with the $OU variable changed.

    Prereqs:
     - Permissions to look up users and their attributes in Source Domain DC
     - RSAT tools installed on the computer/server running this script + AD Powershell Modules
     - Ability to Save to C: Drive (This is where the include file will end up)

#>

# Edit These Variables

# Enter OU where user objects reside
$OU = "OU=Colleagues,DC=SourceDomain,DC=edu";

#Enter the Domain Controller to pull the users from
$DomainController = "Source-DC.SourceDomain.edu";

# Uncomment below line to grab users created after a certain date. Otherwise, script will grab users no matter when they were created
$createdAfter = [DateTime] "12/09/2019 11:40:00"



###--------------------------------------###
## DO NOT change anything under this line ##
###--------------------------------------###
FUNCTION Add-UserToIncludeFile {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$name,
        [Parameter(Mandatory=$true)]
        [string]$samAccountName
    )

    $hash = @{
        'SourceName' = $samAccountName;
        'TargetSAM' = $SamAccountName;
        'TargetUPN' = "$SamAccountName`@TargetDomain.edu";
    };

    New-Object -TypeName PSObject -Property $hash | `
        Select-Object SourceName,TargetSam,TargetUPN | `
        Export-CSV -Path "C:\includeFile_$timeStamp.csv" `
                   -NoTypeInformation -Append;
}

$timeStamp = Get-Date -f MM-dd-yyy-h-m-s

IF ($createdAfter){
    $users = Get-ADUser -SearchBase $OU `
                        -Filter {whenCreated -gt $createdAfter} `
                        -Properties whenCreated `
                        -Server $domainController | `
                        Select Name,SamAccountName;
    $users | %{
    Add-UserToIncludeFile -name $_.Name `
                          -samAccountName $_.SamAccountName
    }
}
ELSE{
    $users = Get-ADUser -SearchBase $OU  `
                        -Filter * `
                        -Server $DomainController | `
                        Select Name,SamAccountName;
    $users | %{
    Add-UserToIncludeFile -name $_.Name `
                        -samAccountName $_.SamAccountName
    }
}
Clear-Host;
Write-Output "`n`n`nCheck for the C:\includeFile_$timeStamp.csv include file`n`n`n"
