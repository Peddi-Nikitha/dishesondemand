# Build and Test Instructions

## Problem Fixed
The video file had **spaces and parentheses** in its filename (`mp4for splashscreen 3 (1).mp4`), which can cause loading issues on Android.

## Changes Made
1. ✅ Renamed video file to `splash_video.mp4` (no spaces, no special characters)
2. ✅ Updated `lib/screens/splash/splash_data.dart` to use new filename
3. ✅ Updated `pubspec.yaml` to reference new filename
4. ✅ Ran `flutter pub get` to register the asset
5. ✅ Ran `flutter clean` to remove old build cache

## Next Steps

### For Android Testing:

1. **Connect your Android device** via USB or start an emulator
2. **Enable USB Debugging** on your Android device
3. **Run the app:**
   ```bash
   flutter run
   ```
   
4. **Or build APK and install manually:**
   ```bash
   flutter build apk --release
   ```
   Then install: `build/app/outputs/flutter-apk/app-release.apk`

### For Web Testing:

```bash
flutter run -d chrome
```

### For Windows Testing:

```bash
flutter run -d windows
```

## What Should Happen

1. App launches and shows splash screens
2. Navigate to 3rd splash screen (swipe left twice or wait)
3. **Video should start playing automatically**
4. Video should loop continuously
5. Video is muted (no sound)

## Debug Information

If video still doesn't play, check the console for these messages:
- `Initializing video: splash_video.mp4`
- `Platform: Web` or `Platform: Mobile`
- `Video initialized: true`
- `Video playing: true`

If you see errors, the video format may need conversion (see VIDEO_CONVERSION_GUIDE.md).

## File Locations

- Video file: `E:\Projects\new_ui\splash_video.mp4`
- Splash data: `lib/screens/splash/splash_data.dart`
- Splash page: `lib/screens/splash/splash_page.dart`
- Assets config: `pubspec.yaml`

## Troubleshooting

### Video not playing on Android
- Make sure you did `flutter clean` before rebuilding
- Check that `splash_video.mp4` exists in project root
- Verify the file is listed in `pubspec.yaml` assets section
- Try building in debug mode first: `flutter run`

### Black screen or loading indicator forever
- The video format may not be compatible
- Convert the video using instructions in VIDEO_CONVERSION_GUIDE.md
- Check console for error messages

### App crashes on splash screen
- Check Logcat for detailed error messages
- Ensure video_player package is properly installed
- Try running on a different device/emulator

## Video Requirements

For best compatibility across all platforms:
- Format: MP4
- Codec: H.264 (baseline or main profile)
- Pixel format: yuv420p
- No audio (or AAC codec)
- Resolution: 720p or lower recommended
- File size: Under 10MB recommended

