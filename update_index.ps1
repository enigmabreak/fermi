$exeFile = Get-ChildItem -Filter *.exe | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if ($exeFile) {
    if ($exeFile.Name -match '\d+\.\d+\.\d+') {
        $version = $matches[0]
        $urlFile = [uri]::EscapeDataString($exeFile.Name)
        # However, [uri]::EscapeDataString encodes spaces as %20 but might also encode other things.
        # Given the html, just replacing spaces is safer.
        $urlFile = $exeFile.Name -replace ' ', '%20'
        
        $html = Get-Content index.html -Raw
        $pattern = '<td>Windows</td>\s*<td>.*?</td>\s*<td><a href=".*?">Download Installer</a></td>'
        $replacement = "<td>Windows</td>`n            <td>$version</td>`n            <td><a href=`"$urlFile`">Download Installer</a></td>"
        
        $html = $html -replace $pattern, $replacement
        Set-Content -Path index.html -Value $html
        Write-Host "Updated index.html to $version and $urlFile"
    }
}
