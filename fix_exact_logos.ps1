$dir = $PSScriptRoot
$htmlPath = "$dir\index.html"

$pathServices = "C:\Users\Lmadec\.gemini\antigravity\brain\dc14a1c0-5a15-4ed7-bbc4-c5ee89f797e5\.user_uploaded\media__1788257556473.jpg"
$path2R = "C:\Users\Lmadec\.gemini\antigravity\brain\dc14a1c0-5a15-4ed7-bbc4-c5ee89f797e5\.user_uploaded\media__1788257540078.png"

$b64Services = "data:image/jpeg;base64," + [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($pathServices))
$b642R = "data:image/png;base64," + [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($path2R))

$html = [System.IO.File]::ReadAllText($htmlPath)

$html = [regex]::Replace($html, 'id="imgAgoraServices"\s+src="[^"]*"', "id=`"imgAgoraServices`" src=`"$b64Services`"")

$html = [regex]::Replace($html, 'id="imgAgora2R"\s+src="[^"]*"', "id=`"imgAgora2R`" src=`"$b642R`"")

[System.IO.File]::WriteAllText($htmlPath, $html)
Write-Host "EXACT LOGOS INJECTED SUCCESSFULLY!"
