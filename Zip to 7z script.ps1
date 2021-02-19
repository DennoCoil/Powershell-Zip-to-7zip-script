#  I spent over 8 hours on this piece of shit.  It took a ZIP file, made a blank folder, and an empty 7z file with only the first couple letters until a space sppeared.
#  If you can figure this out, be my guest.


    $homeLocation = Get-Location
    $IncludeFiles = @("*.zip", "*.rar")
    $foundItem = Get-ChildItem .\ -recurse | where {$_.extension -in ".zip",".rar"}
    $7zipLocation = 'C:\Program Files\7-Zip\7z.exe'
    $7zipArgsCompress = "a -mmt32 -mx9 -sdel $("$fileDirectory\$baseFileName").7z $("$tempFolderPath\*")"
    $7zipArgsUnzip = "e $fullFilePath -o$tempFolderPath"
    $temporaryFolderArray = @()
    $originalFilesArray = @()

<#Function DebugInfo {
    Write-Host " Full archive name: $originalFullName`n",
    "Name of Archive:  $baseFileName`n",
    "Direcotry file is in:  $fileDirectory`n",
    "Full Path for Original Archive:  $fullFilePath`n",
    "Temporary Folder Name:  $tempFolderName`n"
    "Temporary Folder Path:  $tempFolderPath`n"

}#>

#DebugInfo

ForEach ($foundArchive in $foundItem) {

    $originalFullName = $foundArchive.Name
    $baseFileName = $foundArchive.BaseName
    $fileDirectory = $foundArchive.Directory
    $fullFilePath = "$fileDirectory\$originalFullName"
    $tempFolderName = $(get-random -minimum 10000000 -maximum 99999999)
    $tempFolderPath = "$fileDirectory\$tempFolderName"

    $originalFilesArray += "$fullFilePath"
    
    New-Item -Type Directory -Path $tempFolderPath;

    $temporaryFolderArray += "$tempFolderPath"

    Start-Process -FilePath $7zipLocation -ArgumentList $7zipArgsUnzip -Wait
    
        #DebugInfo

    Start-Process -FilePath $7zipLocation -ArgumentList $7zipArgsCompress -Wait

        Write-Host "INFO:  $originalFullName has been recompressed to 7Zip." -ForegroundColor green

        #DebugInfo

}

Read-Host -Prompt "Press any key to continue..."

# This part does not work in ISE, only PowerShell.  Remove-Item is a broken piece of shit.
#Write-Host -ForegroundColor green -Object ('INFO:  Recompression Script Complete.`nPress any key to continue.' -f [System.Console]::ReadKey().Key.ToString());

$folders = 'C:\temp','C:\users\joe\foo'
Get-ChildItem $temporaryFolderArray -r | Where {!$_.PSIsContainer} | Remove-Item -WhatIf

Write-Host "Finally Done" -ForegroundColor DarkGreen
