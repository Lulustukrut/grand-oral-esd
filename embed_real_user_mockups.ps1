Add-Type -AssemblyName System.Drawing

$dir = $PSScriptRoot
$htmlPath = "$dir\index.html"
$folder = "C:\Users\Lmadec\.gemini\antigravity\brain\dc14a1c0-5a15-4ed7-bbc4-c5ee89f797e5\.user_uploaded"

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

Resize-ImgBytes "$folder\media__1788265092757.png" "$dir\real_m1.png" 900
Resize-ImgBytes "$folder\media__1788265182886.png" "$dir\real_m2.png" 900
Resize-ImgBytes "$folder\media__1788265203552.png" "$dir\real_m3.png" 900
Resize-ImgBytes "$folder\media__1788265161399.png" "$dir\real_m4.png" 900

$b64_1 = "data:image/png;base64," + [Convert]::ToBase64String([System.IO.File]::ReadAllBytes("$dir\real_m1.png"))
$b64_2 = "data:image/png;base64," + [Convert]::ToBase64String([System.IO.File]::ReadAllBytes("$dir\real_m2.png"))
$b64_3 = "data:image/png;base64," + [Convert]::ToBase64String([System.IO.File]::ReadAllBytes("$dir\real_m3.png"))
$b64_4 = "data:image/png;base64," + [Convert]::ToBase64String([System.IO.File]::ReadAllBytes("$dir\real_m4.png"))

$html = [System.IO.File]::ReadAllText($htmlPath)

# Replace first mockups array
$firstIdx = $html.IndexOf('mockups: [')
if ($firstIdx -gt 0) {
    $endIdx = $html.IndexOf(']', $firstIdx)
    $endIdx = $html.IndexOf(']', $endIdx + 1)
    
    $before = $html.Substring(0, $firstIdx)
    $after = $html.Substring($endIdx + 1)
    
    $newMockups = @"
mockups: [
          { address: 'agora2r.bzh/accueil-lorient', tag: 'HERO & ACCUEIL LORIENT', img: '$b64_1' },
          { address: 'agora2r.bzh/nos-convives-scolaires', tag: 'PARCOURS CONVIVES', img: '$b64_2' },
          { address: 'agora2r.bzh/restauration-concedee', tag: 'RESTAURATION CONCÉDÉE', img: '$b64_3' },
          { address: 'agora2r.bzh/identite-engagements', tag: 'GALERIE CULINAIRE & 2R', img: '$b64_4' }
        ]
"@
    $html = $before + $newMockups + $after
}

[System.IO.File]::WriteAllText($htmlPath, $html)
Write-Host "REAL USER MOCKUPS EMBEDDED SUCCESSFULLY!"
