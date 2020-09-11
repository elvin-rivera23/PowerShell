<## 
	FOR GITHUB PURPOSES I'M REMOVING ANY SENSITIVE FILE NAMES OR LOCATION NAMES
	I have the working script, but in this case I will use ** on sensitive areas
 ##>





# Get, but do not terminate sessions for the current user, on the local computer.
## Get-PSSessionsForUser

# Terminate all sessions for for the current user, on the local computer.
## (Get-PSSessionsForUser) | Invoke-CimMethod -MethodName Terminate


Set-ExecutionPolicy Unrestricted

function Get-PSSessionsForUser
{
    param(
        [string]$ServerName,
        [string]$UserName
    )

    begin {
        if(($UserName -eq $null) -or ($UserName -eq ""))
        { $UserName = [Environment]::UserName }
        if(($ServerName -eq $null) -or ($ServerName -eq ""))
        { $ServerName = [Environment]::MachineName }
    }

    process {

        Try{

        Get-CimInstance  -ClassName Win32_Process -ComputerName $ServerName | Where-Object { 
            $_.Name -imatch "wsmprovhost.exe"
        } | Where-Object {
            $UserName -eq (Invoke-CimMethod -InputObject $_ -MethodName GetOwner).User
        }

        }

        ## Catches any errors
        Catch 
        { 
            Write-Error $_ 
    
        }
    }
}

$DCs = Get-ADDomainController -Server CLC-**1 -Filter *

##$DC = Get-ADDomainController -Server CLC-**1 -Filter {HostName -eq "M-**1"}

$Credential = Get-Credential

foreach($DC in $DCs){

Get-PSSessionsForUser -ServerName $DC.Name -UserName Visal.le | Invoke-CimMethod -MethodName Terminate

Pause

}

