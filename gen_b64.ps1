$dir = $PSScriptRoot
$s = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes("$dir\logo_services_clean.png"))
$r = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes("$dir\logo_2r_clean.png"))

[System.IO.File]::WriteAllText("$dir\b64_s.txt", $s)
[System.IO.File]::WriteAllText("$dir\b64_r.txt", $r)
