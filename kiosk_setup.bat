@echo off
setlocal EnableDelayedExpansion
title Chicket Kiosk Setup
color 0A

:: ============================================
:: CHICKET KIOSK DEVICE SETUP SCRIPT
:: ============================================
:: Prerequisites:
::   - Device is factory reset (no accounts added)
::   - USB debugging enabled
::   - Device connected via USB
::   - ADB installed and in PATH
:: ============================================

set "PACKAGE_NAME=com.diode.chicket"
set "MAIN_ACTIVITY=com.diode.chicket.MainActivity"
set "APK_PATH=build\app\outputs\flutter-apk\app-release.apk"

echo.
echo ============================================
echo    CHICKET KIOSK SETUP SCRIPT
echo ============================================
echo.

:: ============================================
:: STEP 1: Check if ADB is installed
:: ============================================
echo [1/10] Checking ADB installation...
where adb >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [ERROR] ADB is not installed or not in PATH!
    echo.
    echo Please install Android SDK Platform Tools and add to PATH:
    echo https://developer.android.com/studio/releases/platform-tools
    echo.
    goto :error_exit
)
echo [OK] ADB found.
echo.

:: ============================================
:: STEP 2: Start ADB server
:: ============================================
echo [2/10] Starting ADB server...
adb start-server >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [WARN] Could not start ADB server, trying to restart...
    adb kill-server >nul 2>&1
    timeout /t 2 /nobreak >nul
    adb start-server >nul 2>&1
)
echo [OK] ADB server running.
echo.

:: ============================================
:: STEP 3: Wait for device connection
:: ============================================
echo [3/10] Waiting for device connection...
echo        (Make sure USB debugging is enabled on device)
echo.

set "DEVICE_FOUND=0"
set "RETRY_COUNT=0"
set "MAX_RETRIES=30"

:wait_for_device
adb devices | findstr /R /C:"device$" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    set "DEVICE_FOUND=1"
    goto :device_found
)

set /a RETRY_COUNT+=1
if %RETRY_COUNT% geq %MAX_RETRIES% (
    echo [ERROR] No device found after %MAX_RETRIES% attempts!
    echo.
    echo Troubleshooting:
    echo   1. Enable USB debugging: Settings ^> Developer Options ^> USB Debugging
    echo   2. Try different USB cable
    echo   3. Install device drivers
    echo   4. Accept USB debugging prompt on device
    echo.
    goto :error_exit
)

echo        Attempt %RETRY_COUNT%/%MAX_RETRIES%... waiting for device
timeout /t 2 /nobreak >nul
goto :wait_for_device

:device_found
echo [OK] Device connected!

:: Get device info
for /f "tokens=1" %%a in ('adb devices ^| findstr /R /C:"device$"') do set "DEVICE_ID=%%a"
echo        Device ID: %DEVICE_ID%
echo.

:: ============================================
:: STEP 4: Check device state
:: ============================================
echo [4/10] Checking device state...

:: Check if device is in correct state (not unauthorized)
adb devices | findstr /C:"unauthorized" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo [ERROR] Device is unauthorized!
    echo.
    echo Please accept the USB debugging prompt on the device screen.
    echo Check "Always allow from this computer" and tap "Allow".
    echo.
    echo Waiting for authorization...
    timeout /t 10 /nobreak >nul
    
    adb devices | findstr /C:"unauthorized" >nul 2>&1
    if %ERRORLEVEL% equ 0 (
        echo [ERROR] Device still unauthorized. Please authorize and run again.
        goto :error_exit
    )
)

:: Check if device is offline
adb devices | findstr /C:"offline" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo [ERROR] Device is offline!
    echo.
    echo Try: Disconnect and reconnect the USB cable.
    goto :error_exit
)

echo [OK] Device state is valid.
echo.

:: ============================================
:: STEP 5: Check for existing accounts (Device Owner requirement)
:: ============================================
echo [5/10] Checking for existing accounts...

:: Check if any accounts exist (device owner cannot be set with accounts)
adb shell pm list users 2>nul | findstr /C:"UserInfo" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo [INFO] Checking Google accounts...
    
    adb shell dumpsys account 2>nul | findstr /C:"Account {" >nul 2>&1
    if %ERRORLEVEL% equ 0 (
        echo [WARN] Accounts found on device!
        echo.
        echo For Device Owner setup, ALL accounts must be removed.
        echo.
        set /p REMOVE_ACCOUNTS="Do you want to continue anyway? (y/n): "
        if /i "!REMOVE_ACCOUNTS!" neq "y" (
            echo.
            echo Please remove all accounts from:
            echo   Settings ^> Accounts ^> [Each Account] ^> Remove
            echo.
            echo Then run this script again.
            goto :error_exit
        )
        echo [WARN] Continuing without removing accounts. Device Owner may fail.
        echo.
    ) else (
        echo [OK] No Google accounts found.
    )
) else (
    echo [OK] Device appears fresh.
)
echo.

:: ============================================
:: STEP 6: Check if app is installed, install if needed
:: ============================================
echo [6/10] Checking app installation...

adb shell pm list packages | findstr /C:"%PACKAGE_NAME%" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo [OK] App already installed.
    
    set /p REINSTALL="Do you want to reinstall the app? (y/n): "
    if /i "!REINSTALL!" equ "y" (
        echo        Uninstalling old version...
        adb shell pm uninstall %PACKAGE_NAME% >nul 2>&1
        goto :install_app
    )
) else (
    :install_app
    echo        Installing app...
    
    if exist "%APK_PATH%" (
        adb install -r "%APK_PATH%" >nul 2>&1
        if %ERRORLEVEL% neq 0 (
            echo [ERROR] Failed to install APK!
            echo.
            echo Make sure you have built the release APK:
            echo   flutter build apk --release
            echo.
            goto :error_exit
        )
        echo [OK] App installed successfully.
    ) else (
        echo [WARN] APK not found at: %APK_PATH%
        echo        Please install the app manually or build it first:
        echo        flutter build apk --release
        echo.
        
        :: Check if already installed
        adb shell pm list packages | findstr /C:"%PACKAGE_NAME%" >nul 2>&1
        if %ERRORLEVEL% neq 0 (
            echo [ERROR] App is not installed! Please install it first.
            goto :error_exit
        )
    )
)
echo.

:: ============================================
:: STEP 7: Set Device Owner (for Lock Task Mode)
:: ============================================
echo [7/10] Setting up Device Owner for Lock Task Mode...

:: Check if device owner is already set
adb shell dumpsys device_policy 2>nul | findstr /C:"Device Owner" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo [INFO] A Device Owner is already set.
    
    adb shell dumpsys device_policy 2>nul | findstr /C:"%PACKAGE_NAME%" >nul 2>&1
    if %ERRORLEVEL% equ 0 (
        echo [OK] Chicket is already the Device Owner.
    ) else (
        echo [WARN] Another app is Device Owner.
        echo        You may need to factory reset to change Device Owner.
    )
) else (
    echo        Attempting to set Device Owner...
    
    :: Try to set device owner
    adb shell dpm set-device-owner %PACKAGE_NAME%/.MainActivity 2>&1 | findstr /C:"Success" >nul 2>&1
    if %ERRORLEVEL% equ 0 (
        echo [OK] Device Owner set successfully!
    ) else (
        :: Check common errors
        adb shell dpm set-device-owner %PACKAGE_NAME%/.MainActivity 2>&1 > temp_dpm_output.txt
        
        findstr /C:"already several users" temp_dpm_output.txt >nul 2>&1
        if %ERRORLEVEL% equ 0 (
            echo [ERROR] Multiple users exist on device.
            echo         Factory reset required.
            del temp_dpm_output.txt 2>nul
            goto :skip_device_owner
        )
        
        findstr /C:"already has an owner" temp_dpm_output.txt >nul 2>&1
        if %ERRORLEVEL% equ 0 (
            echo [ERROR] Device already has an owner.
            echo         Factory reset required.
            del temp_dpm_output.txt 2>nul
            goto :skip_device_owner
        )
        
        findstr /C:"accounts on the device" temp_dpm_output.txt >nul 2>&1
        if %ERRORLEVEL% equ 0 (
            echo [ERROR] Accounts exist on device.
            echo         Remove all accounts from Settings and try again.
            del temp_dpm_output.txt 2>nul
            goto :skip_device_owner
        )
        
        findstr /C:"Unknown admin" temp_dpm_output.txt >nul 2>&1
        if %ERRORLEVEL% equ 0 (
            echo [ERROR] App does not have DeviceAdminReceiver.
            echo         Lock Task mode requires additional setup.
            del temp_dpm_output.txt 2>nul
            goto :skip_device_owner
        )
        
        echo [WARN] Could not set Device Owner. Output:
        type temp_dpm_output.txt
        del temp_dpm_output.txt 2>nul
        
        :skip_device_owner
        echo.
        echo [INFO] Continuing without Device Owner...
        echo        Basic kiosk features will still work.
        echo.
    )
)
echo.

:: ============================================
:: STEP 8: Configure Kiosk Settings
:: ============================================
echo [8/10] Configuring kiosk settings...

:: Disable status bar expansion
echo        - Disabling status bar...
adb shell settings put global policy_control immersive.full=* >nul 2>&1

:: Disable heads-up notifications
echo        - Disabling heads-up notifications...
adb shell settings put global heads_up_notifications_enabled 0 >nul 2>&1

:: Set screen timeout to maximum (30 minutes, wake lock handles rest)
echo        - Setting screen timeout...
adb shell settings put system screen_off_timeout 1800000 >nul 2>&1

:: Disable screen lock
echo        - Disabling screen lock...
adb shell settings put secure lockscreen.disabled 1 >nul 2>&1

:: Stay awake while charging
echo        - Enabling stay awake while charging...
adb shell settings put global stay_on_while_plugged_in 3 >nul 2>&1

:: Disable auto-rotate (force portrait)
echo        - Locking to portrait orientation...
adb shell settings put system accelerometer_rotation 0 >nul 2>&1
adb shell settings put system user_rotation 0 >nul 2>&1

:: Disable touch sounds
echo        - Disabling touch sounds...
adb shell settings put system sound_effects_enabled 0 >nul 2>&1

:: Hide navigation bar (optional - can make it harder to debug)
:: echo        - Hiding navigation bar...
:: adb shell wm overscan 0,0,0,-100 >nul 2>&1

echo [OK] Kiosk settings configured.
echo.

:: ============================================
:: STEP 9: Set as Default Home Launcher
:: ============================================
echo [9/10] Setting app as default home launcher...

:: This sets the preferred home activity
adb shell cmd package set-home-activity %PACKAGE_NAME%/%MAIN_ACTIVITY% 2>nul
if %ERRORLEVEL% neq 0 (
    echo [WARN] Could not set home activity via command.
    echo        User will be prompted to select launcher on first home press.
) else (
    echo [OK] Set as preferred home launcher.
)
echo.

:: ============================================
:: STEP 10: Launch App and Final Setup
:: ============================================
echo [10/10] Launching app...

:: Clear any existing app data (fresh start)
set /p CLEAR_DATA="Clear app data for fresh start? (y/n): "
if /i "%CLEAR_DATA%" equ "y" (
    echo        Clearing app data...
    adb shell pm clear %PACKAGE_NAME% >nul 2>&1
)

:: Start the app
adb shell am start -n %PACKAGE_NAME%/%MAIN_ACTIVITY% >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [WARN] Could not auto-launch app.
    echo        Please launch manually from device.
) else (
    echo [OK] App launched!
)
echo.

:: ============================================
:: SETUP COMPLETE
:: ============================================
echo ============================================
echo    SETUP COMPLETE!
echo ============================================
echo.
echo Kiosk features enabled:
echo   [x] Fullscreen immersive mode
echo   [x] Screen always on
echo   [x] Back button disabled
echo   [x] Status bar disabled
echo   [x] Notifications disabled
echo   [x] Screen lock disabled
echo   [x] Portrait orientation locked
echo   [x] Set as home launcher
echo.
echo Next steps:
echo   1. Press Home button on device
echo   2. Select "Chicket" as home app
echo   3. Choose "Always"
echo.
echo To UNDO kiosk settings, run: kiosk_reset.bat
echo.
goto :success_exit

:: ============================================
:: ERROR EXIT
:: ============================================
:error_exit
echo.
echo ============================================
echo    SETUP FAILED
echo ============================================
echo.
echo Please fix the errors above and try again.
echo.
pause
exit /b 1

:: ============================================
:: SUCCESS EXIT
:: ============================================
:success_exit
echo.
pause
exit /b 0
