Add-Type -AssemblyName System.Drawing

$dir = $PSScriptRoot

function Resize-ImgBytes($srcPath, $destPath, $maxWidth) {
    $bytes = [System.IO.File]::ReadAllBytes($srcPath)
    $ms = New-Object System.IO.MemoryStream(,$bytes)
    $img = [System.Drawing.Image]::FromStream($ms)
    $ratio = $maxWidth / $img.Width
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

Resize-ImgBytes "C:\Users\Lmadec\.gemini\antigravity\brain\dc14a1c0-5a15-4ed7-bbc4-c5ee89f797e5\.user_uploaded\media__1788255490098.png" "$dir\logo_services_clean.png" 300
Resize-ImgBytes "C:\Users\Lmadec\.gemini\antigravity\brain\dc14a1c0-5a15-4ed7-bbc4-c5ee89f797e5\.user_uploaded\media__1788255307301.png" "$dir\logo_2r_clean.png" 200
