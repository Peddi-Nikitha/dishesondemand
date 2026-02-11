@echo off
REM This script updates the video path in splash_data.dart

echo ========================================
echo Update Video Path Script
echo ========================================
echo.

set FILE=lib\screens\splash\splash_data.dart

echo Updating %FILE%...
echo.

REM Use PowerShell to replace the video filename
powershell -Command "(Get-Content '%FILE%') -replace 'mp4for splashscreen 3 \(1\)\.mp4', 'splash_video_web.mp4' | Set-Content '%FILE%'"

if %ERRORLEVEL% EQU 0 (
    echo SUCCESS: Video path updated successfully!
    echo.
    echo Updated: imagePath: 'splash_video_web.mp4'
    echo.
    echo Next steps:
    echo 1. Run: flutter clean
    echo 2. Run: flutter pub get
    echo 3. Run: flutter run -d chrome
    echo.
) else (
    echo ERROR: Failed to update video path!
    echo.
)

pause

