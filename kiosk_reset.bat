@echo off
setlocal EnableDelayedExpansion
title Chicket Kiosk Reset
color 0C

:: ============================================
:: CHICKET KIOSK RESET SCRIPT
:: ============================================
:: Reverts all kiosk settings to normal
:: ============================================

set "PACKAGE_NAME=com.diode.chicket"

echo.
echo ============================================
echo    CHICKET KIOSK RESET SCRIPT
echo ============================================
echo.
echo This will UNDO all kiosk settings and restore
echo normal device behavior.
echo.
set /p CONFIRM="Are you sure you want to continue? (y/n): "
if /i "%CONFIRM%" neq "y" (
    echo Cancelled.
    goto :eof
)
echo.

:: ============================================
:: Check ADB
:: ============================================
echo [1/6] Checking ADB...
where adb >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [ERROR] ADB not found!
    goto :error_exit
)

adb devices | findstr /R /C:"device$" >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [ERROR] No device connected!
    goto :error_exit
)
echo [OK] Device connected.
echo.

:: ============================================
:: Remove Device Owner
:: ============================================
echo [2/6] Removing Device Owner...
adb shell dpm remove-active-admin %PACKAGE_NAME%/.MainActivity >nul 2>&1
echo [OK] Device Owner removed (if was set).
echo.

:: ============================================
:: Restore System Settings
:: ============================================
echo [3/6] Restoring system settings...

:: Re-enable status bar
echo        - Restoring status bar...
adb shell settings put global policy_control null >nul 2>&1

:: Re-enable heads-up notifications
echo        - Restoring notifications...
adb shell settings put global heads_up_notifications_enabled 1 >nul 2>&1

:: Restore screen timeout (2 minutes)
echo        - Restoring screen timeout...
adb shell settings put system screen_off_timeout 120000 >nul 2>&1

:: Re-enable screen lock
echo        - Restoring screen lock...
adb shell settings put secure lockscreen.disabled 0 >nul 2>&1

:: Disable stay awake
echo        - Disabling always-on...
adb shell settings put global stay_on_while_plugged_in 0 >nul 2>&1

:: Re-enable auto-rotate
echo        - Restoring auto-rotate...
adb shell settings put system accelerometer_rotation 1 >nul 2>&1

:: Re-enable touch sounds
echo        - Restoring touch sounds...
adb shell settings put system sound_effects_enabled 1 >nul 2>&1

:: Reset navigation bar overscan
echo        - Resetting navigation bar...
adb shell wm overscan reset >nul 2>&1

echo [OK] System settings restored.
echo.

:: ============================================
:: Clear Home Launcher Preference
:: ============================================
echo [4/6] Clearing home launcher preference...
adb shell pm set-home-activity "" >nul 2>&1
adb shell cmd package set-home-activity "" >nul 2>&1
echo [OK] Home launcher preference cleared.
echo.

:: ============================================
:: Stop the App
:: ============================================
echo [5/6] Stopping Chicket app...
adb shell am force-stop %PACKAGE_NAME% >nul 2>&1
echo [OK] App stopped.
echo.

:: ============================================
:: Uninstall Option
:: ============================================
echo [6/6] App uninstall option...
set /p UNINSTALL="Do you want to uninstall Chicket? (y/n): "
if /i "%UNINSTALL%" equ "y" (
    adb shell pm uninstall %PACKAGE_NAME% >nul 2>&1
    if %ERRORLEVEL% equ 0 (
        echo [OK] App uninstalled.
    ) else (
        echo [WARN] Could not uninstall. May need manual removal.
    )
) else (
    echo [OK] App kept installed.
)
echo.

:: ============================================
:: DONE
:: ============================================
echo ============================================
echo    RESET COMPLETE!
echo ============================================
echo.
echo Device has been restored to normal mode.
echo You may need to:
echo   1. Restart the device
echo   2. Select a new default launcher when pressing Home
echo.
pause
exit /b 0

:error_exit
echo.
pause
exit /b 1
