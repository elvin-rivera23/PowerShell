<## 
	FOR GITHUB PURPOSES I'M REMOVING ANY SENSITIVE FILE NAMES OR LOCATION NAMES
	I have the working script, but in this case I will use ** on sensitive areas
 ##>


#########################################################################################################################################################
# Export DNS Forward Lookup Zones Records To A CSV file
# v1.0
# Written By: Elvin Rivera
# Date: 1/7/20
# 
# Desc: This script will gather the DNS Records of targeted DNS Forward Zone and export to the C drive a CSV file.
#
#       The user running this script must have permission levels of a Domain Administrator. To run the function
#       only two information is need the Domain Controller's computer name (EX: SJVC-ATA-DC.College.domain) and the 
#       Zone Name (EX: College.domain or College2.domain).
#
# **************** There are usually more that one DNS Forward Zones on a DC. Remember to run this script multiple times. ****************
#########################################################################################################################################################

FUNCTION DNS-Record{
    Param(
        [Parameter(Mandatory=$true)]
        [string]$ZoneName,
        [Parameter(Mandatory=$true)]
        [string]$DomainController
    )
 
 ## Connects to the targeted DC ##
 Enter-PSSession -ComputerName $DomainController   
 
 ## Creates a CSV files at the root of the C Drive that corresponds with the Zone Name ##
 $FilePath = "C:\" + $ZoneName + "-DNSrecord.csv" 

 ## Gathers the DNS Records and exports to the targeted FilePath. RecordData was tricky as it could be both a IP or an FQDN. RecordType was used to resolve this issue. ##
 $DNSdata = Get-DnsServerResourceRecord -ComputerName $DomainController -ZoneName $ZoneName | Where-Object {$_.RecordType -eq "CNAME" -or $_.RecordType -eq "A" }  |Select HostName,RecordType, RecordClass,DistinguishedName, Timestamp,@{n='IP';E={$_.RecordData.IPV4Address}},@{n='CName';E={$_.RecordData.HostNameAlias}} | Export-Csv -Path $FilePath -NoTypeInformation -Append

 ## Disconnects from the target DC ##
 Exit-PSSession

 Write-Host "DNS Record Export Completed" -ForegroundColor Green

 }

 DNS-Record -ZoneName College.domain -DomainController CLC-**1