# How to Install FFmpeg on Windows

FFmpeg is required to convert the video to a web-compatible format.

## Option 1: Using Windows Package Manager (Recommended)

Open PowerShell as Administrator and run:
```powershell
winget install FFmpeg
```

## Option 2: Using Chocolatey

If you have Chocolatey installed:
```powershell
choco install ffmpeg
```

## Option 3: Manual Installation

1. Download FFmpeg from: https://ffmpeg.org/download.html
   - Click "Windows" under "Get packages & executable files"
   - Download the latest release build
   
2. Extract the zip file to a folder (e.g., `C:\ffmpeg`)

3. Add FFmpeg to PATH:
   - Open System Properties → Environment Variables
   - Under "System variables", find "Path"
   - Click "Edit" → "New"
   - Add the path to FFmpeg bin folder (e.g., `C:\ffmpeg\bin`)
   - Click "OK" on all windows

4. Verify installation:
   - Open a new PowerShell window
   - Run: `ffmpeg -version`
   - You should see version information

## After Installation

1. Close and reopen any terminal windows
2. Run `CONVERT_VIDEO.bat` to convert your video
3. The script will create a web-compatible video file

## Troubleshooting

### "ffmpeg is not recognized"
- Make sure you added FFmpeg to PATH
- Close and reopen your terminal
- Verify with: `where ffmpeg`

### Conversion fails
- Check that the input video file exists
- Make sure you have enough disk space
- Try running PowerShell as Administrator

