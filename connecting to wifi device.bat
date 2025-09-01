@echo off
echo ========================================
echo   Flutter Wi-Fi Debugging Starter
echo ========================================

:: Change this path to where your adb.exe is located
set ADB_PATH=C:\Users\Administrator\AppData\Local\Android\Sdk\platform-tools\adb.exe

:: Ask for the device IP
set /p device_ip=Enter your device IP address: 

echo [*] Restarting adb on tcpip port 5555...
"%ADB_PATH%" tcpip 5555

echo [*] Connecting to device %device_ip% ...
"%ADB_PATH%" connect %device_ip%:5555

echo [*] Running Flutter app...
flutter run

pause
