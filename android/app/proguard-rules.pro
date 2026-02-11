## Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Video Player
-keep class io.flutter.plugins.videoplayer.** { *; }
-keepclassmembers class io.flutter.plugins.videoplayer.** { *; }

# ExoPlayer (used by video_player)
-keep class com.google.android.exoplayer2.** { *; }
-keepclassmembers class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**

# Media3 (newer ExoPlayer)
-keep class androidx.media3.** { *; }
-keepclassmembers class androidx.media3.** { *; }
-dontwarn androidx.media3.**

# Keep all native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep video codecs
-keep class * extends android.media.MediaCodec { *; }
-keep class * extends android.media.MediaPlayer { *; }

# Asset manager
-keep class android.content.res.AssetManager { *; }
-keepclassmembers class android.content.res.AssetManager { *; }

# Google Maps
-keep class com.google.android.gms.maps.** { *; }
-keep class com.google.android.gms.location.** { *; }
-dontwarn com.google.android.gms.**

