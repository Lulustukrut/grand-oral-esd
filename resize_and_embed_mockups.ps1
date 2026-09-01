Add-Type -AssemblyName System.Drawing

$dir = $PSScriptRoot
$htmlPath = "$dir\index.html"

function Resize-ImgBytes($srcPath, $destPath, $maxWidth) {
    $bytes = [System.IO.File]::ReadAllBytes($srcPath)
    $ms = New-Object System.IO.MemoryStream(,$bytes)
    $img = [System.Drawing.Image]::FromStream($ms)
    $ratio = $maxWidth / $img.Width
    if ($ratio -gt 1) { $ratio = 1 }
    $newHeight = [int]($img.Height * $ratio)
    $bmp = New-Object System.Drawing.Bitmap($maxWidth, $newHeight)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($img, 0, 0, $maxWidth, $newHeight)
    
    $outMs = New-Object System.IO.MemoryStream
    $bmp.Save($outMs, [System.Drawing.Imaging.ImageFormat]::Png)
    [System.IO.File]::WriteAllBytes($destPath, $outMs.ToArray())
    
    $g.Dispose()
    $bmp.Dispose()
    $img.Dispose()
    $ms.Dispose()
    $outMs.Dispose()
}

Resize-ImgBytes "$dir\agora2r_mockup1.png" "$dir\m1_opt.png" 900
Resize-ImgBytes "$dir\agora2r_mockup2.png" "$dir\m2_opt.png" 900
Resize-ImgBytes "$dir\agora2r_mockup3.png" "$dir\m3_opt.png" 900
Resize-ImgBytes "$dir\agora2r_mockup4.png" "$dir\m4_opt.png" 900

$b64_1 = "data:image/png;base64," + [Convert]::ToBase64String([System.IO.File]::ReadAllBytes("$dir\m1_opt.png"))
$b64_2 = "data:image/png;base64," + [Convert]::ToBase64String([System.IO.File]::ReadAllBytes("$dir\m2_opt.png"))
$b64_3 = "data:image/png;base64," + [Convert]::ToBase64String([System.IO.File]::ReadAllBytes("$dir\m3_opt.png"))
$b64_4 = "data:image/png;base64," + [Convert]::ToBase64String([System.IO.File]::ReadAllBytes("$dir\m4_opt.png"))

$html = [System.IO.File]::ReadAllText($htmlPath)

$html = $html.Replace("img: 'agora2r_mockup1.png'", "img: '$b64_1'")
$html = $html.Replace("img: 'agora2r_mockup3.png'", "img: '$b64_3'")
$html = $html.Replace("img: 'agora2r_mockup4.png'", "img: '$b64_4'")
$html = $html.Replace("img: 'agora2r_mockup2.png'", "img: '$b64_2'")

[System.IO.File]::WriteAllText($htmlPath, $html)
Write-Host "MOCKUPS EMBEDDED SUCCESSFULLY IN BASE64!"
