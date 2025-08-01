# ==== Configuration ====
$serverList = Get-Content "C:\Reports\report.txt"
$from = ""
$to = ""
$subject = "Daily Disk Report - $(Get-Date -Format 'yyyy-MM-dd')"
$smtpServer = "smtp.gmail.com"
$smtpPort = 587
$password = ""  # app password

# ==== Build Report ====
$report = @()

foreach ($server in $serverList) {
    try {
        $disks = Get-CimInstance -ComputerName $server -ClassName Win32_LogicalDisk -Filter "DriveType=3" -ErrorAction Stop | 
        Select-Object @{Name='Server';Expression={$server}},
                      DeviceID,
                      @{Name='Size(GB)';Expression={[math]::round($_.Size / 1GB, 2)}},
                      @{Name='Free(GB)';Expression={[math]::round($_.FreeSpace / 1GB, 2)}},
                      @{Name='Used(GB)';Expression={[math]::round(($_.Size - $_.FreeSpace) / 1GB, 2)}},
                      @{Name='Usage(%)';Expression={[math]::round((($_.Size - $_.FreeSpace)/$_.Size)*100, 2)}}

        $report += $disks
    } catch {
        $report += [PSCustomObject]@{
            Server    = $server
            DeviceID  = "N/A"
            "Size(GB)"= "Error"
            "Free(GB)"= "Error"
            "Used(GB)"= "Error"
            "Usage(%)"= "Failed to connect"
        }
    }
}

# Convert to plain text table
$body = $report | Format-Table -AutoSize | Out-String

# ==== Send Email ====
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object PSCredential ($from, $securePassword)

Send-MailMessage -From $from -To $to -Subject $subject -Body $body `
    -SmtpServer $smtpServer -Port $smtpPort -UseSsl -Credential $cred
