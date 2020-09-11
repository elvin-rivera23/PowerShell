<## 
	FOR GITHUB PURPOSES I'M REMOVING ANY SENSITIVE FILE NAMES OR LOCATION NAMES
	I have the working script, but in this case I will use ** on sensitive areas
 ##>





$SourceComputerName = 'S**'
 
$DestinationComputerName = 'CLC-**'
 
 
# Gets the settings for printers from a saved CSV file on the current user's desktop 
$printers= import-csv "$env:USERPROFILE\desktop\printers.csv" 
 
# cycles through the printers and queries the source computer to match the port specified in the CSV file. Creates the port and printer on the destination server 
foreach ($printer in $printers) {  
     
    $port=get-printerport -ComputerName $SourceComputerName|? {$_.Name -eq $printer.PortName} 
     
    Add-PrinterPort -ComputerName $DestinationComputerName -Name $port.Name -PrinterHostAddress $port.PrinterHostAddress  
    Add-Printer -ComputerName $DestinationComputerName -Name $printer.Name -DriverName $printer.DriverName -PortName $printer.PortName -Comment $printer.Comment -ShareName $printer.ShareName 
 
    [boolean]$shared=[System.Convert]::ToBoolean($printer.Shared) 
    [boolean]$published=[System.Convert]::ToBoolean($printer.Published) 
 
    Set-printer -ComputerName $DestinationComputerName -Name $printer.Name -Shared $shared -Published $published