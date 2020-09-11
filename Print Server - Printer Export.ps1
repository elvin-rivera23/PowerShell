<## 
	FOR GITHUB PURPOSES I'M REMOVING ANY SENSITIVE FILE NAMES OR LOCATION NAMES
	I have the working script, but in this case I will use ** on sensitive areas
 ##>



$SourceComputerName = 'CI-**.college.domain'
Get-Credential

# Gets the shared printers on the machine 
$p=get-printer -ComputerName $SourceComputerName|?{$_.Shared -eq $true} 
 
# Saves the printer settings in a CSV file on the current user's desktop 
$p|select *|Export-Csv -Path "$env:USERPROFILE\Desktop\printers.csv" -NoTypeInformation