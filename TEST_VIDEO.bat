@echo off
echo ========================================
echo Flutter Video Test Script
echo ========================================
echo.

echo Step 1: Checking if video file exists...
if exist "splash_video.mp4" (
    echo [OK] Video file found: splash_video.mp4
) else (
    echo [ERROR] Video file not found!
    echo Expected location: %CD%\splash_video.mp4
    pause
    exit /b 1
)
echo.

echo Step 2: Checking Flutter installation...
where flutter >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Flutter is not installed or not in PATH
    pause
    exit /b 1
)
echo [OK] Flutter found
echo.

echo Step 3: Getting Flutter dependencies...
flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to get Flutter dependencies
    pause
    exit /b 1
)
echo [OK] Dependencies updated
echo.

echo Step 4: Checking connected devices...
flutter devices
echo.

echo ========================================
echo Ready to test!
echo ========================================
echo.
echo Choose your test platform:
echo 1. Android (device or emulator)
echo 2. Chrome (web)
echo 3. Windows (desktop)
echo 4. Build APK only
echo.

set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" (
    echo.
    echo Running on Android...
    echo Watch the 3rd splash screen for video playback!
    echo.
    flutter run
) else if "%choice%"=="2" (
    echo.
    echo Running on Chrome...
    echo Navigate to 3rd splash screen to see video!
    echo.
    flutter run -d chrome
) else if "%choice%"=="3" (
    echo.
    echo Running on Windows...
    echo Navigate to 3rd splash screen to see video!
    echo.
    flutter run -d windows
) else if "%choice%"=="4" (
    echo.
    echo Building APK...
    echo.
    flutter build apk --release
    echo.
    if %ERRORLEVEL% EQU 0 (
        echo [OK] APK built successfully!
        echo Location: build\app\outputs\flutter-apk\app-release.apk
        echo.
        echo Install it on your Android device and test!
    ) else (
        echo [ERROR] APK build failed!
    )
) else (
    echo Invalid choice!
)

echo.
pause

