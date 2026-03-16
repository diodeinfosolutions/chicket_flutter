@echo off
setlocal
set "PKG=com.diode.chicket"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$files = adb shell 'run-as %PKG% find . -name \"kiosk_log_*.txt\"' 2>$null; " ^
    "if ($files -match 'package not debuggable') { " ^
    "    Write-Host 'ERROR: App is not debuggable. Run: flutter run --debug' -ForegroundColor Red; " ^
    "    exit 1 " ^
    "} " ^
    "if ($null -eq $files -or $files.Count -eq 0) { " ^
    "    Write-Host 'Searching via recursive ls...' -ForegroundColor Gray; " ^
    "    $files = adb shell 'run-as %PKG% ls -R' | Select-String 'kiosk_log_.*\.txt' | ForEach-Object { $_.ToString().Trim() } " ^
    "} " ^
    "if ($null -eq $files -or $files.Count -eq 0) { " ^
    "    Write-Host 'No logs found anywhere.' -ForegroundColor Yellow; " ^
    "} else { " ^
    "    $count = 0; " ^
    "    foreach ($f in $files) { " ^
    "        $path = $f.Trim(); " ^
    "        if ($path) { " ^
    "            $name = $path.Split('/')[-1]; " ^
    "            Write-Host \"Pulling: $name\"; " ^
    "            adb shell \"run-as %PKG% cat $path\" > \"$name\"; " ^
    "            $count++; " ^
    "        } " ^
    "    } " ^
    "    Write-Host \"Finished. $count logs extracted.\" -ForegroundColor Green; " ^
    "} "
pause
