<## FOR GITHUB PURPOSES I'M REMOVING ANY SENSITIVE FILE NAMES OR LOCATION NAMES
	I have the working script, but in this case I will use ** on sensitive areas
 ##>




<#

    Created by: Elvin Rivera
    Date: 1/21/2020
    Description: This is a script to get all Domain Controllers in the SJVC environement and to add DHCP Failover for each of them


#>



# Get a list of DCs in our Environment using AD's Attribute Editor to get the OU Path
# Right click on the DC OU in AD and go to attribute editor and get the Distinguished Name
# Added Export-csv to use in the next portion "Export Scopes"
# Otherwise, this is the command (using '@()' ) to list the DCs in an Array call it by the $ADServers[array index] ---- e.g. $ADServers[1] will bring up the 2nd DC
# NOTE: AZ-**, AZ-**2, CLC-**1, CLC-**2 (doesn't need it)

$OUpath = 'OU=Domain Controllers,DC=collegename,DC=edu'
$ADServers = @(Get-ADComputer -Filter * -SearchBase $OUpath | Where-Object {$_.Name -notlike "AZ-**" -and $_.Name -notlike "AZ-**2" -and $_.Name -notlike "CLC-**1" -and $_.Name -notlike "CLC-**2"} | Sort-Object  | Select-Object Name) | export-csv -Path "C:\Users\Elvin**\Desktop\DCList.csv" -NoTypeInformation


<#



Name           
----           
A**-DC         
A**C1      
AZ-**1  --------- NOT INCLUDED IN FAILOVER RELATIONSHIP     
AZ-**2  --------- NOT INCLUDED IN FAILOVER RELATIONSHIP      
CC-**1      
C-**1        
CLC-**1  --------- NOT INCLUDED IN FAILOVER RELATIONSHIP     
CLC-**2  --------- NOT INCLUDED IN FAILOVER RELATIONSHIP  
D-**1        
F-**1        
H-**1        
HS-**1      
L-**1       
MA-**1       
M-**1        
O-**1      
P-**C         
RC-**1       
SB-**C    
S-**C    
SJ**-AZ-**r
SJ**-B**1     
SJ**-F**1   
SJ**-V**1     
T-**1        


#>


## ------------------------- Export Scopes -------------------------

$import = Import-Csv -Path "C:\Users\Elvin**\Desktop\DCList.csv" 

foreach ($DCs in $import) {



Export-DhcpServer -ComputerName $DCs.Name -File ("C:\Users\Elvin**\Desktop\DCScopes\" + $DCs.Name + "-Config.xml") -Force
Get-DhcpServerv4Scope -ComputerName $DCs.Name | Export-Clixml -Path ("C:\Users\Elvin**\Desktop\DCScopes\" + $DCs.Name + "-Scopes.xml") -Force


}

## XML is harder to read so if you need to check the txt version just run this one-liner below and change the DC server name where it says "DCNAME"
## Get-DhcpServerv4Scope -ComputerName "DCNAME" | Out-File -FilePath ("C:\Users\Elvin**\Desktop\DCNAME-Scopes.txt") -Force


## ------------------------- DHCP FAILOVER -------------------------
## This is to add DHCP failovers
## 1/22/2020 Still need to take in a list of DCs and pass it onto $DCServer ; $scopes would go into foreach loop


$sharedsecret = "Mt****"

$DCServer = "SJ**-**1.**.edu".ToLower()

## $scopes = @(Get-DhcpServerv4Scope -ComputerName "H-**1" | Select-Object -Property ScopeID)

$scopes = @(Get-DhcpServerv4Scope -ComputerName $DCServer | Select-Object -ExpandProperty ScopeID)


## This is to create teh DHCP Failover relationship
## Select a Server you want to get the scopes from, create a relationship name, and chose the server you're failing over to
## ScopeID has to be passed to ExpandProperty if you want to use it in this CMDLet
## Be Careful when choosing "ServerRole", this is to configure the VM for COMPUTERNAME parameter not the VM for PARTNERSERVER parameter
## to clarify, it's primary (active --ComputerName) failing over to secondary (standby -- s***c.edu)


Add-DhcpServerv4Failover -ComputerName $DCServer -Name ($DCserver + "-sj**.college.edu") -PartnerServer "SJ**.college.edu" `
-ScopeId $scopes -ReservePercent 5 -ServerRole "Active" `
-MaxClientLeadTime 1:00:00 -AutoStateTransition $True -StateSwitchInterval 1:00:00 -SharedSecret $sharedsecret



## This is to check the DHCP Failover relationships of a given computer 
Get-DhcpServerv4Failover -ComputerName SJ** | Sort-Object -Property PartnerServer | Select-Object PartnerServer, Name, ServerRole, Mode, State

