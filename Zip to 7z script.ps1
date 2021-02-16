#Use this only for cases of compressing 1 file per 1 archive

$TempFolderPath = ".\TEMPORARYFOLDER\"

$IncludeFiles = @("*.zip", "*.rar")

$ExcludeFiles = @("*.txt", "*.bat", "*.exe", "*.xml", "*.pdf", "*.png", "*.7z", "*.mp4", "*.zip", "*.jpg", "*.wav", "*.wad", "*.csv")

$FoundItem = Get-ChildItem * -Include $IncludeFiles


#EXTRACTION

New-Item -Type Directory -Path $TempFolderPath

ForEach ($zippedfile In $FoundItem) {

    Expand-7Zip -ArchiveFileName "$($zippedfile.Name)" -TargetPath $TempFolderPath
    Remove-Item $zippedfile
}

#COMPRESSION

$RomFile = Get-ChildItem -Path $TempFolderPath -Exclude $ExcludeFiles

ForEach ($Rom In $RomFile) {

    $RomGet = $($Rom.BaseName + '.7z')
    
    <# -Path is the INPUT and -Archive FileName is the OUTPUT#>
    Compress-7Zip -Path $Rom -ArchiveFileName $RomGet -CompressionLevel Ultra -CompressionMethod LZMA2 -Format SevenZip -DisableRecursion
}

Move-Item -Path $($TempFolderPath + "\*.7z") -Destination ".."

Remove-Item -Path $TempFolderPath -Recurse
