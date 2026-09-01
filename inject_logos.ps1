$dir = $PSScriptRoot
$htmlPath = "$dir\index.html"
$s = [System.IO.File]::ReadAllText("$dir\b64_s.txt").Trim()
$r = [System.IO.File]::ReadAllText("$dir\b64_r.txt").Trim()

$html = [System.IO.File]::ReadAllText($htmlPath)

$html = [regex]::Replace($html, 'id="imgAgoraServices"\s+src="[^"]*"', "id=`"imgAgoraServices`" src=`"data:image/png;base64,$s`"")

$html = [regex]::Replace($html, 'id="imgAgora2R"\s+src="[^"]*"', "id=`"imgAgora2R`" src=`"data:image/png;base64,$r`"")

[System.IO.File]::WriteAllText($htmlPath, $html)
Write-Host "Logos injected successfully!"
