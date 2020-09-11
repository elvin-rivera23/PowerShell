<## 
	FOR GITHUB PURPOSES I'M REMOVING ANY SENSITIVE FILE NAMES OR LOCATION NAMES
	I have the working script, but in this case I will use ** on sensitive areas
 ##>




Set-ExecutionPolicy Unrestricted -Force

try{

    ## Source Folder Path ##
    $SourcePath = "C:\Users\Elvin**\Desktop\Source"

    ## Destination Folder Path ##
    $DestinationPath = "C:\Users\Elvin**\Desktop\Destination"

    ## Source Folder Items
    $SourceFolder = Get-ChildItem -Recurse -Path $SourcePath -Force -ErrorAction SilentlyContinue | Out-File -FilePath "$env:userprofile\desktop\Failed-Files.txt" -Append

    ## Destination Folder Items
    $DestinationFolder = Get-ChildItem -Recurse -Path $DestinationPath -Force -ErrorAction SilentlyContinue | Out-File -FilePath "$env:userprofile\desktop\Failed-Files.txt" -Append

    ## Compares all the content in the Source Folder and Destination Folder and creates a list of all the object differences
    $FolderList = Compare-Object -ReferenceObject $SourceFolder -DifferenceObject $DestinationFolder -Property Name -PassThru

    ## Checks if FolderList is empty/null, if so the rest of the script is skiiped
    if($FolderList -ne $null){

        ## For every object in the FolderList creates a custom PSobject and creates a log of the info
        Foreach($File in $FolderList){

                ## Checks if the $File's is a folder or a file
                $FileType = (Get-Item $File.FullName) -is [System.IO.DirectoryInfo]

                ## True equals a folder
                if( $FileType -eq $true){
                    $Extension = "Folder"
                }

                ## False equals a file
                Else{
                    $Extension = $File.Extension
                }

                ## Creates $FILE to Store info ##
                $Item = New-Object PSObject -Property @{
                    Name = $File.Name
                    FilePath = $File.FullName
                    FileType = $Extension
                }

                ## Sends the $File info to a CSV file 
                $Item | Select Name, FilePath, FileType | Export-csv -Path "C:\Users\Elvin**\Desktop\ComparedFolders.csv" -NoTypeInformation -Append

        }

    }
    else{

            Write-Host "There are no differences between the $SourcePath and the $DestinationPath" -ForegroundColor Yellow

    }

}

Catch{

      Write-Host "An error occurred that could not be resolved." -ForegroundColor Red

}