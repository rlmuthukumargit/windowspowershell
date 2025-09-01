# === Configuration ===
$servers = @("muthukumar", "192.168.1.6")  # Replace with your server names or IPs
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$reportFolder = "C:\Reports"  # Make sure this path exists or use New-Item to create it
$csvPath = Join-Path $reportFolder "DiskUsage_$timestamp.csv"
$htmlPath = Join-Path $reportFolder "DiskUsage_$timestamp.html"

# === Create Folder if Not Exists ===
if (!(Test-Path $reportFolder)) {
    New-Item -ItemType Directory -Path $reportFolder -Force | Out-Null
}

# === Initialize Report Data ===
$diskReport = @()

foreach ($server in $servers) {
    try {
        $disks = Get-CimInstance -ComputerName $server -ClassName Win32_LogicalDisk -Filter "DriveType=3" -ErrorAction Stop

        foreach ($disk in $disks) {
            $sizeGB = [math]::Round($disk.Size / 1GB, 2)
            $freeGB = [math]::Round($disk.FreeSpace / 1GB, 2)
            $usedGB = [math]::Round(($disk.Size - $disk.FreeSpace) / 1GB, 2)
            $usagePct = if ($disk.Size -ne 0) { [math]::Round((($disk.Size - $disk.FreeSpace) / $disk.Size) * 100, 2) } else { 0 }

            $diskReport += [PSCustomObject]@{
                Server     = $server
                Drive      = $disk.DeviceID
                'Size(GB)' = $sizeGB
                'Free(GB)' = $freeGB
                'Used(GB)' = $usedGB
                'Usage(%)' = $usagePct
            }
        }
    } catch {
        $diskReport += [PSCustomObject]@{
            Server     = $server
            Drive      = "N/A"
            'Size(GB)' = "N/A"
            'Free(GB)' = "N/A"
            'Used(GB)' = "N/A"
            'Usage(%)' = "Failed to connect"
        }
    }
}

# === Export to CSV and HTML ===
$diskReport | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8

$diskReport | ConvertTo-Html -Property Server, Drive, 'Size(GB)', 'Free(GB)', 'Used(GB)', 'Usage(%)' `
    -Title "Disk Usage Report" -PreContent "<h2>Windows Server Disk Usage Report - $timestamp</h2>" |
    Out-File -FilePath $htmlPath -Encoding UTF8

Write-Host "`n✅ Disk report saved:"
Write-Host "CSV : $csvPath"
Write-Host "HTML: $htmlPath"
