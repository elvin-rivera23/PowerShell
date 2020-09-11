#############################################################################################################################
# Creating DHCP Scopes for Domain Controllers 
# v1.0
# Written By: Elvin
# Date: 1/7/20
#
# 
# Desc: This script will create all necessary DHCP scopes for a SJVC domain controller (remotely).
#       Scopes:
#              College_PC, College_PRINT, College_WIFI, IT_STAFF, MERAKI_WAP, Student_PC, Student_PRINT, VDI, Student_WIFI, GUEST_WIFI
#
#       The user running this script must have permission levels of a Domain Administrator. To run the function
#       only two information is need the Domain Controller's computer name (EX: SJ-**.College.Domain) and the 
#       campus id number (EX:Atascadero = 16).
#
# **************** These DHCP scopes wil be created deactivated. Remember to ACTIVATE the DHCP scopes. ****************
#############################################################################################################################
FUNCTION NewDC-DHCPscopes{
    Param(
        [Parameter(Mandatory=$true)]
        [string]$CampusIPScheme,
        [Parameter(Mandatory=$true)]
        [string]$DomainController
    )

Write-Host "##########################Creating Scopes For DC##########################" -ForegroundColor Yellow

##Connects to DC##
Enter-PSSession -ComputerName $DomainController

$CampusID = $CampusIPScheme
$CampusDC = $DomainController

$DC_IP = "10." + $CampusID + "."

$DNSserver = "10." +$CampusID + ".1.10"

############# DC's Server Level Scopes #############

## Set DNS Servers ##
Set-DhcpServerv4OptionValue -ComputerName $DomainController -OptionId 6 -Value $DNSserver , 10.**.**.10 , 10.**.**.11

## Set DNS Domain Name ##
Set-DhcpServerv4OptionValue -ComputerName $DomainController -OptionId 15 -Value SJVC.edu 

## Set NTP Server ##
Set-DhcpServerv4OptionValue -ComputerName $DomainController -OptionId 42 -Value 10.**.**.24
#################################################################################

############# College PC Scope ###############
Write-Host "##########################College PC Scope Created##########################" -ForegroundColor DarkGreen

$Scope_IP_Start = $DC_IP + "**.1"

$Scope_IP_End = $DC_IP + "**.254"

$Scope_Exclude = $DC_IP + "**.20"

$ScopeID = $DC_IP + "**.0"

$Router = "10." + $CampusID + ".**.1"

Add-DhcpServerv4Scope -Name ‘College_PC’ -StartRange $Scope_IP_Start -EndRange $Scope_IP_End -SubnetMask 255.255.255.0 -Description ‘Vlan 3’ –cn $CampusDC -LeaseDuration 1:00:00:00 -State InActive
Add-Dhcpserverv4ExclusionRange -ComputerName $DomainController -ScopeId $ScopeID -StartRange $Scope_IP_Start -EndRange $Scope_Exclude
Set-DHCPServerv4OptionValue -ComputerName $DomainController -ScopeId $ScopeID -Router $Router
##########################################

############# College PRINT Scope #############
Write-Host "##########################College PRINT Scope Created##########################" -ForegroundColor DarkGreen

$Scope_IP_Start = $DC_IP + "**.1"

$Scope_IP_End = $DC_IP + "**.254"

$Scope_Exclude = $DC_IP + "**.20"

$ScopeID = $DC_IP + "**.0"

$Router = "10." + $CampusID + ".**.1"

Add-DhcpServerv4Scope -Name ‘College_PRINT’ -StartRange $Scope_IP_Start -EndRange $Scope_IP_End -SubnetMask 255.255.255.0 -Description ‘Vlan 4’ –cn $CampusDC -LeaseDuration 6:00:00:00 -State InActive
Add-Dhcpserverv4ExclusionRange -ComputerName $DomainController -ScopeId $ScopeID -StartRange $Scope_IP_Start -EndRange $Scope_Exclude
Set-DHCPServerv4OptionValue -ComputerName $DomainController -ScopeId $ScopeID -Router $Router
##########################################

############# College WIFI Scope #############
Write-Host "##########################College WIFI Scope Created##########################" -ForegroundColor DarkGreen

$Scope_IP_Start = $DC_IP + "**.1"

$Scope_IP_End = $DC_IP + "**.254"

$Scope_Exclude = $DC_IP + "**.20"

$Router = "10." + $CampusID + ".**.1"

$ScopeID = $DC_IP + "**.0"
Add-DhcpServerv4Scope -Name ‘College_WIFI’ -StartRange $Scope_IP_Start -EndRange $Scope_IP_End -SubnetMask 255.255.255.0 -Description ‘College Wifi’ –cn $CampusDC -LeaseDuration 8:00:00 -State InActive
Add-Dhcpserverv4ExclusionRange -ComputerName $DomainController -ScopeId $ScopeID -StartRange $Scope_IP_Start -EndRange $Scope_Exclude
Set-DHCPServerv4OptionValue -ComputerName $DomainController -ScopeId $ScopeID -Router $Router
##########################################

############## IT STAFF Scope ##############
Write-Host "##########################IT STAFF Scope Created##########################" -ForegroundColor DarkGreen

$Scope_IP_Start = $DC_IP + "**.1"

$Scope_IP_End = $DC_IP + "**.254"

$Scope_Exclude = $DC_IP + "**.20"

$Router = "10." + $CampusID + ".**.1"

$ScopeID = $DC_IP + "**.0"
Add-DhcpServerv4Scope -Name ‘IT_STAFF’ -StartRange $Scope_IP_Start -EndRange $Scope_IP_End -SubnetMask 255.255.255.0 -Description ‘IT Staff’ –cn $CampusDC -LeaseDuration 1:00:00:00 -State InActive
Add-Dhcpserverv4ExclusionRange -ComputerName $DomainController -ScopeId $ScopeID -StartRange $Scope_IP_Start -EndRange $Scope_Exclude
Set-DHCPServerv4OptionValue -ComputerName $DomainController -ScopeId $ScopeID -Router $Router
##########################################

############# MERAKI WAP Scope #############
Write-Host "##########################MERAKI WAP Scope Created##########################" -ForegroundColor DarkGreen

$Scope_IP_Start = $DC_IP + "**..1"

$Scope_IP_End = $DC_IP + "**..254"

$Scope_Exclude = $DC_IP + "**..20"

$Router = "10." + $CampusID + ".**..1"

$ScopeID = $DC_IP + "**..0"
Add-DhcpServerv4Scope -Name ‘MERAKI_WAP’ -StartRange $Scope_IP_Start -EndRange $Scope_IP_End -SubnetMask 255.255.255.0 –cn $CampusDC -LeaseDuration 3:00:00:00 -State InActive
Add-Dhcpserverv4ExclusionRange -ComputerName $DomainController -ScopeId $ScopeID -StartRange $Scope_IP_Start -EndRange $Scope_Exclude
Set-DHCPServerv4OptionValue -ComputerName $DomainController -ScopeId $ScopeID -Router $Router
##########################################

############### Student PC Scope ###############
Write-Host "##########################Student PC Scope Created##########################" -ForegroundColor DarkGreen

$Scope_IP_Start = $DC_IP + "**.1"

$Scope_IP_End = $DC_IP + "**.254"

$Scope_Exclude = $DC_IP + "**.20"

$Router = "10." + $CampusID + ".**.1"

$ScopeID = $DC_IP + "**..0"
Add-DhcpServerv4Scope -Name ‘Student_PC’ -StartRange $Scope_IP_Start -EndRange $Scope_IP_End -SubnetMask 255.255.255.0 –cn $CampusDC -LeaseDuration 8:00:00 -State InActive
Add-Dhcpserverv4ExclusionRange -ComputerName $DomainController -ScopeId $ScopeID -StartRange $Scope_IP_Start -EndRange $Scope_Exclude
Set-DHCPServerv4OptionValue -ComputerName $DomainController -ScopeId $ScopeID -Router $Router
##########################################

############### Student PRINT Scope ###############
Write-Host "##########################Student PRINT Scope Created##########################" -ForegroundColor DarkGreen

$Scope_IP_Start = $DC_IP + "**.1"

$Scope_IP_End = $DC_IP + "**.254"

$Scope_Exclude = $DC_IP + "**.20"

$Router = "10." + $CampusID + ".**.1"

$ScopeID = $DC_IP + "**..0"
Add-DhcpServerv4Scope -Name ‘Student_PRINT’ -StartRange $Scope_IP_Start -EndRange $Scope_IP_End -SubnetMask 255.255.255.0 –cn $CampusDC -LeaseDuration 6:00:00 -State InActive
Add-Dhcpserverv4ExclusionRange -ComputerName $DomainController -ScopeId $ScopeID -StartRange $Scope_IP_Start -EndRange $Scope_Exclude
Set-DHCPServerv4OptionValue -ComputerName $DomainController -ScopeId $ScopeID -Router $Router
##########################################

############### VDI Scope ###############
Write-Host "##########################VDI Scope Created##########################" -ForegroundColor DarkGreen

$Scope_IP_Start = $DC_IP + "**.1"

$Scope_IP_End = $DC_IP + "**.254"

$Scope_Exclude = $DC_IP + "**.20"

$Router = "10." + $CampusID + ".**.1"

$ScopeID = $DC_IP + "**.0"
Add-DhcpServerv4Scope -Name ‘VDI’ -StartRange $Scope_IP_Start -EndRange $Scope_IP_End -SubnetMask 255.255.255.0 -Description 'VDI/ChromeBox' –cn $CampusDC -LeaseDuration 12:00:00 -State InActive
Add-Dhcpserverv4ExclusionRange -ComputerName $DomainController -ScopeId $ScopeID -StartRange $Scope_IP_Start -EndRange $Scope_Exclude
Set-DHCPServerv4OptionValue -ComputerName $DomainController -ScopeId $ScopeID -Router $Router
##########################################

############### Student_WIFI Scope ###############
Write-Host "##########################Student WIFI Scope Created##########################" -ForegroundColor DarkGreen

$Scope_IP_Start = $DC_IP + "**.1"

$Scope_IP_End = $DC_IP + "**.254"

$Scope_Exclude = $DC_IP + "**.20"

$Router = "10." + $CampusID + ".**.1"

$ScopeID = $DC_IP + "**.0"
Add-DhcpServerv4Scope -Name ‘Student_WIFI’ -StartRange $Scope_IP_Start -EndRange $Scope_IP_End -SubnetMask 255.255.255.0 -Description 'Student Laptop WIFI' –cn $CampusDC -LeaseDuration 8:00:00 -State InActive
Add-Dhcpserverv4ExclusionRange -ComputerName $DomainController -ScopeId $ScopeID -StartRange $Scope_IP_Start -EndRange $Scope_Exclude
Set-DHCPServerv4OptionValue -ComputerName $DomainController -ScopeId $ScopeID -Router $Router
##########################################

############### GUEST_WIFI Scope ###############
Write-Host "##########################GUEST WIFI Scope Created##########################" -ForegroundColor DarkGreen

$Scope_IP_Start = $DC_IP + "252.1"

$Scope_IP_End = $DC_IP + "253.254"

$Scope_Exclude_Start = $DC_IP + "253.0"

$Scope_Exclude = $DC_IP + "253.20"

$Router = "10." + $CampusID + ".253.1"

$ScopeID = $DC_IP + "252.0"
Add-DhcpServerv4Scope -Name ‘GUEST_WIFI’ -StartRange $Scope_IP_Start -EndRange $Scope_IP_End -SubnetMask 255.255.254.0 -Description 'Guest WIFI' –cn $CampusDC -LeaseDuration 4:00:00 -State InActive
Add-Dhcpserverv4ExclusionRange -ComputerName $DomainController -ScopeId $ScopeID -StartRange $Scope_Exclude_Start -EndRange $Scope_Exclude
Set-DHCPServerv4OptionValue -ComputerName $DomainController -ScopeId $ScopeID -Router $Router
##########################################

## Disconnects the DC ##
Exit-PSSession

Write-Host "##########################All Scopes Created##########################" -ForegroundColor Green

}

NewDC-DHCPscopes -CampusIPScheme 7 -DomainController H-**.College.Domain