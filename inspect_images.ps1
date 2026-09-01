Add-Type -AssemblyName System.Drawing

$folder = "C:\Users\Lmadec\.gemini\antigravity\brain\dc14a1c0-5a15-4ed7-bbc4-c5ee89f797e5\.user_uploaded"

Get-ChildItem "$folder\*" | ForEach-Object {
    $file = $_
    $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
    $ms = New-Object System.IO.MemoryStream(,$bytes)
    try {
        $img = [System.Drawing.Image]::FromStream($ms)
        [PSCustomObject]@{
            Name = $file.Name
            Size = $file.Length
            Width = $img.Width
            Height = $img.Height
        }
        $img.Dispose()
    } catch {}
    $ms.Dispose()
} | Format-Table -AutoSize
