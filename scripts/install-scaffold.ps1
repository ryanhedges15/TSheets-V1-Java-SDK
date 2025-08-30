Param(
    [string]$ManifestPath = "scaffold-bundle.txt",
    [switch]$WhatIf
)

if (-not (Test-Path $ManifestPath)) {
    Write-Error "Manifest file not found: $ManifestPath"
    exit 1
}

$content = Get-Content -Raw -Path $ManifestPath

# Pattern matches blocks like:
#   #BEGIN_FILE: relative/path
#   ...content...
#   #END_FILE
$regex = [regex]"(?ms)^#BEGIN_FILE:\s*(.+?)\s*\r?\n(.*?)^#END_FILE\s*$"
$matches = $regex.Matches($content)

if ($matches.Count -eq 0) {
    Write-Error "No file blocks found in manifest. Ensure blocks are delimited by '#BEGIN_FILE: <path>' and '#END_FILE'."
    exit 1
}

foreach ($m in $matches) {
    $relPath = $m.Groups[1].Value.Trim()
    $fileBody = $m.Groups[2].Value

    $fullPath = Join-Path -Path (Get-Location) -ChildPath $relPath
    $dir = Split-Path -Path $fullPath -Parent

    if ($WhatIf) {
        Write-Host "[WhatIf] Would write: $relPath"
        continue
    }

    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }

    [System.IO.File]::WriteAllText($fullPath, $fileBody, [System.Text.Encoding]::UTF8)
    Write-Host "Wrote: $relPath"
}

Write-Host "Done. You can now run Maven from repo root, e.g.:"
Write-Host "  mvn -q -e install"

