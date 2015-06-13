function Remove-Duplicates(){
    <#

    .SYNOPSIS

    Deletes duplicate files in a folder and all subfolders



    .DESCRIPTION

    Remove-Duplicates function gets MD5 hashes of all files in given folder and deletes any duplicates.


    .PARAMETER folder 

    Folder to search duplicates in


    .EXAMPLE

    Delete duplicates in a folder

    Remove-Duplicates "D:\Photos\"


    .NOTES

    Do NOT use this for root of your drive or any program files folders.
    
    Some files are meant to be duplicated in multiple places.

    I.e. do not use on \Windows folder or \Program Files

    #>
    param ($folder)
    
    $files = gci -File -Recurse $folder
    $hashes = @{}

    # Stop on errors to prevent unwanted deletions
    $ErrorActionPreference = "stop"

    foreach ($file in $files){
        $path = $file.FullName
        $hash = (Get-FileHash -LiteralPath $path -Algorithm MD5).Hash
        
        If ($hashes.ContainsKey($hash)){
            Write "Duplicate found, following files have the same hash. Deleting duplicate!`r`n$hash`r`n$path`r`n$($hashes.Get_Item($hash))"
            Remove-Item -LiteralPath $path
        } Else {
            $hashes.Add($hash, $path)            
        }
    }
    
}