$adbPath = "C:\Users\Md Khan Bahadur Sadi\AppData\Local\Android\sdk\platform-tools\adb.exe"
Write-Host "Killing ADB server..."
& $adbPath kill-server
Write-Host "Starting ADB server..."
& $adbPath start-server
Write-Host "ADB server restarted."