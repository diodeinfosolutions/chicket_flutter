@echo off
setlocal EnableDelayedExpansion
title Chicket Kiosk Diagnostics
color 0B

:: ============================================
:: CHICKET KIOSK DIAGNOSTICS SCRIPT
:: ============================================
:: Checks device status and troubleshoots issues
:: ============================================

set "PACKAGE_NAME=com.diode.chicket"
set "MAIN_ACTIVITY=com.diode.chicket.MainActivity"

echo.
echo ============================================
echo    CHICKET KIOSK DIAGNOSTICS
echo ============================================
echo.

:: ============================================
:: ADB STATUS
:: ============================================
echo [ADB STATUS]
echo ----------------------------------------

where adb >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ADB Installed:      NO [!]
    echo.
    echo Please install Android SDK Platform Tools.
    goto :eof
) else (
    for /f "tokens=*" %%a in ('adb version 2^>nul ^| findstr /C:"Android Debug Bridge"') do echo ADB Version:        %%a
)

adb devices 2>nul | findstr /R /C:"device$" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Device Connected:   YES
    for /f "tokens=1" %%a in ('adb devices ^| findstr /R /C:"device$"') do echo Device ID:          %%a
) else (
    adb devices 2>nul | findstr /C:"unauthorized" >nul 2>&1
    if %ERRORLEVEL% equ 0 (
        echo Device Connected:   UNAUTHORIZED [!]
        echo                     Accept USB debugging prompt on device
    ) else (
        adb devices 2>nul | findstr /C:"offline" >nul 2>&1
        if %ERRORLEVEL% equ 0 (
            echo Device Connected:   OFFLINE [!]
            echo                     Reconnect USB cable
        ) else (
            echo Device Connected:   NO [!]
            echo                     Enable USB debugging on device
        )
    )
    echo.
    echo Cannot continue diagnostics without device connection.
    goto :end
)
echo.

:: ============================================
:: DEVICE INFO
:: ============================================
echo [DEVICE INFO]
echo ----------------------------------------
for /f "tokens=*" %%a in ('adb shell getprop ro.product.model 2^>nul') do echo Model:              %%a
for /f "tokens=*" %%a in ('adb shell getprop ro.product.manufacturer 2^>nul') do echo Manufacturer:       %%a
for /f "tokens=*" %%a in ('adb shell getprop ro.build.version.release 2^>nul') do echo Android Version:    %%a
for /f "tokens=*" %%a in ('adb shell getprop ro.build.version.sdk 2^>nul') do echo API Level:          %%a
echo.

:: ============================================
:: APP STATUS
:: ============================================
echo [APP STATUS]
echo ----------------------------------------

adb shell pm list packages 2>nul | findstr /C:"%PACKAGE_NAME%" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo App Installed:      YES
    
    for /f "tokens=2 delims==" %%a in ('adb shell dumpsys package %PACKAGE_NAME% 2^>nul ^| findstr /C:"versionName"') do echo App Version:        %%a
    
    :: Check if running
    adb shell pidof %PACKAGE_NAME% >nul 2>&1
    if %ERRORLEVEL% equ 0 (
        echo App Running:        YES
    ) else (
        echo App Running:        NO
    )
) else (
    echo App Installed:      NO [!]
    echo                     Run: flutter build apk --release
    echo                     Then: adb install build\app\outputs\flutter-apk\app-release.apk
)
echo.

:: ============================================
:: KIOSK STATUS
:: ============================================
echo [KIOSK STATUS]
echo ----------------------------------------

:: Device Owner
adb shell dumpsys device_policy 2>nul | findstr /C:"%PACKAGE_NAME%" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Device Owner:       YES (Chicket)
) else (
    adb shell dumpsys device_policy 2>nul | findstr /C:"Device Owner" >nul 2>&1
    if %ERRORLEVEL% equ 0 (
        echo Device Owner:       YES (Other App) [!]
    ) else (
        echo Device Owner:       NO
        echo                     (Optional - for full lock task mode)
    )
)

:: Home Launcher
adb shell cmd package resolve-activity -a android.intent.action.MAIN -c android.intent.category.HOME 2>nul | findstr /C:"%PACKAGE_NAME%" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Default Launcher:   YES (Chicket)
) else (
    echo Default Launcher:   NO
    echo                     Press Home and select Chicket
)

:: Check accounts
adb shell dumpsys account 2>nul | findstr /C:"Account {" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Accounts Present:   YES [!]
    echo                     May prevent Device Owner setup
) else (
    echo Accounts Present:   NO (Good for kiosk)
)
echo.

:: ============================================
:: SYSTEM SETTINGS
:: ============================================
echo [SYSTEM SETTINGS]
echo ----------------------------------------

for /f "tokens=*" %%a in ('adb shell settings get global policy_control 2^>nul') do (
    if "%%a"=="immersive.full=*" (
        echo Immersive Mode:     ENABLED
    ) else if "%%a"=="null" (
        echo Immersive Mode:     DISABLED
    ) else (
        echo Immersive Mode:     %%a
    )
)

for /f "tokens=*" %%a in ('adb shell settings get global heads_up_notifications_enabled 2^>nul') do (
    if "%%a"=="0" (
        echo Notifications:      DISABLED
    ) else (
        echo Notifications:      ENABLED
    )
)

for /f "tokens=*" %%a in ('adb shell settings get system screen_off_timeout 2^>nul') do (
    set /a TIMEOUT_MIN=%%a/60000
    echo Screen Timeout:     !TIMEOUT_MIN! minutes
)

for /f "tokens=*" %%a in ('adb shell settings get global stay_on_while_plugged_in 2^>nul') do (
    if "%%a"=="0" (
        echo Stay Awake:         DISABLED
    ) else if "%%a"=="3" (
        echo Stay Awake:         ENABLED (USB+AC)
    ) else (
        echo Stay Awake:         PARTIAL (%%a)
    )
)

for /f "tokens=*" %%a in ('adb shell settings get system accelerometer_rotation 2^>nul') do (
    if "%%a"=="0" (
        echo Auto-Rotate:        LOCKED
    ) else (
        echo Auto-Rotate:        ENABLED
    )
)
echo.

:: ============================================
:: QUICK ACTIONS
:: ============================================
echo [QUICK ACTIONS]
echo ----------------------------------------
echo 1. Launch Chicket app
echo 2. Force stop Chicket app
echo 3. Clear app data
echo 4. Restart device
echo 5. Open Settings on device
echo 6. Take screenshot
echo 0. Exit
echo.
set /p ACTION="Select action (0-6): "

if "%ACTION%"=="1" (
    echo Launching app...
    adb shell am start -n %PACKAGE_NAME%/%MAIN_ACTIVITY% >nul 2>&1
    echo Done.
) else if "%ACTION%"=="2" (
    echo Stopping app...
    adb shell am force-stop %PACKAGE_NAME% >nul 2>&1
    echo Done.
) else if "%ACTION%"=="3" (
    echo Clearing app data...
    adb shell pm clear %PACKAGE_NAME% >nul 2>&1
    echo Done.
) else if "%ACTION%"=="4" (
    echo Restarting device...
    adb reboot >nul 2>&1
    echo Device is restarting...
) else if "%ACTION%"=="5" (
    echo Opening Settings...
    adb shell am start -a android.settings.SETTINGS >nul 2>&1
    echo Done.
) else if "%ACTION%"=="6" (
    echo Taking screenshot...
    adb exec-out screencap -p > kiosk_screenshot_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.png 2>nul
    echo Screenshot saved.
) else if "%ACTION%"=="0" (
    goto :end
) else (
    echo Invalid option.
)

:end
echo.
pause
