@echo off
REM This script converts the video to web-compatible format using FFmpeg

echo ========================================
echo Video Conversion Script for Flutter Web
echo ========================================
echo.

REM Check if FFmpeg is installed
where ffmpeg >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: FFmpeg is not installed or not in PATH
    echo.
    echo Please install FFmpeg first:
    echo 1. Download from: https://ffmpeg.org/download.html
    echo 2. Or use: winget install FFmpeg
    echo 3. Or use: choco install ffmpeg
    echo.
    pause
    exit /b 1
)

echo FFmpeg found!
echo.

REM Set input and output file names
set INPUT_VIDEO=mp4for splashscreen 3 (1).mp4
set OUTPUT_VIDEO=splash_video_web.mp4

echo Converting video to web-compatible format...
echo Input: %INPUT_VIDEO%
echo Output: %OUTPUT_VIDEO%
echo.
echo This may take a minute...
echo.

REM Run FFmpeg conversion with web-compatible settings
ffmpeg -i "%INPUT_VIDEO%" -c:v libx264 -profile:v baseline -level 3.0 -pix_fmt yuv420p -an -movflags +faststart -y "%OUTPUT_VIDEO%"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo SUCCESS: Video converted successfully!
    echo ========================================
    echo.
    echo Output file: %OUTPUT_VIDEO%
    echo.
    echo Next steps:
    echo 1. The new video file has been created in the project root
    echo 2. Run the UPDATE_VIDEO_PATH.bat script to update your app
    echo 3. Or manually update lib\screens\splash\splash_data.dart
    echo.
) else (
    echo.
    echo ERROR: Video conversion failed!
    echo Please check the input file and try again.
    echo.
)

pause

