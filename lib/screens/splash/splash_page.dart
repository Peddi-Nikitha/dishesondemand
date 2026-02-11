import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/animated_image.dart';
import 'splash_data.dart';

/// Individual splash page widget with animated image, headline, and body text
class SplashPage extends StatefulWidget {
  final SplashData data;

  const SplashPage({
    super.key,
    required this.data,
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> 
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isVideoInitialized = false;
  String? _errorMessage;
  bool _isDisposed = false;
  AnimationController? _imageAnimationController;
  Animation<double>? _fadeAnimation;
  Animation<double>? _scaleAnimation;
  
  // Animations for 1st splash screen (index 0)
  AnimationController? _firstScreenAnimationController;
  Animation<double>? _headlineFadeAnimation;
  Animation<Offset>? _headlineSlideAnimation;
  Animation<double>? _bodyFadeAnimation;
  Animation<Offset>? _bodySlideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animations for 1st splash screen (index 0)
    if (widget.data.pageIndex == 0) {
      _firstScreenAnimationController = AnimationController(
        duration: const Duration(milliseconds: 1200),
        vsync: this,
      );
      
      // Headline animations (starts after image)
      _headlineFadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _firstScreenAnimationController!,
          curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
        ),
      );
      
      _headlineSlideAnimation = Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _firstScreenAnimationController!,
          curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic),
        ),
      );
      
      // Body text animations (starts after headline)
      _bodyFadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _firstScreenAnimationController!,
          curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
        ),
      );
      
      _bodySlideAnimation = Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _firstScreenAnimationController!,
          curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic),
        ),
      );
      
      // Start animation
      _firstScreenAnimationController!.forward();
    }
    
    // Initialize animation controller for 2nd splash screen (index 1)
    // Only initialize if it's NOT a video (for backward compatibility)
    if (widget.data.pageIndex == 1 && !widget.data.imagePath.endsWith('.mp4')) {
      _imageAnimationController = AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this,
      );
      
      _fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _imageAnimationController!,
          curve: Curves.easeIn,
        ),
      );
      
      _scaleAnimation = Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _imageAnimationController!,
          curve: Curves.easeOutCubic,
        ),
      );
      
      // Start animation
      _imageAnimationController?.forward();
    }
    
    // CRITICAL FIX: Initialize video after context is available
    // Use post-frame callback to ensure context is ready (required for Theme.of)
    // Support video for both 2nd (index 1) and 3rd (index 2) splash screens
    if ((widget.data.pageIndex == 1 || widget.data.pageIndex == 2) && 
        widget.data.imagePath.endsWith('.mp4')) {
      debugPrint('=== Video page detected (page ${widget.data.pageIndex}) ===');
      debugPrint('Video file: ${widget.data.imagePath}');
      // Use post-frame callback to ensure context is available
      // Add extra delay for 2nd splash screen to ensure clean state
      final delayMs = widget.data.pageIndex == 1 ? 300 : 100;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: delayMs), () {
          if (mounted && !_isDisposed) {
            debugPrint('Starting video initialization for page ${widget.data.pageIndex} after ${delayMs}ms delay');
            _initializeVideo();
          } else {
            debugPrint('⚠️ Widget not mounted or disposed, skipping video init for page ${widget.data.pageIndex}');
          }
        });
      });
    }
  }

  Future<void> _initializeVideo() async {
    if (!mounted || _isDisposed) return;
    
    try {
      debugPrint('=== Video Initialization Start ===');
      debugPrint('Video path: ${widget.data.imagePath}');
      debugPrint('Page index: ${widget.data.pageIndex}');
      debugPrint('Platform: ${kIsWeb ? "Web" : "Mobile"}');
      debugPrint('Is Release Mode: ${!kDebugMode}');
      // Removed Theme.of(context) call - not available in initState()
      debugPrint('Widget mounted: $mounted, disposed: $_isDisposed');
      debugPrint('Current video controller state: ${_videoController?.value.isInitialized}');
      debugPrint('Chewie controller exists: ${_chewieController != null}');
      
      // CRITICAL FIX: Use explicit asset path with package prefix
      // This ensures proper asset resolution in release builds
      final String videoPath = widget.data.imagePath;
      debugPrint('Loading video from: $videoPath');
      
      // Add small delay to ensure assets are ready and previous controllers are disposed
      // Longer delay for 2nd splash screen to ensure clean initialization
      final delayMs = widget.data.pageIndex == 1 ? 200 : 100;
      await Future.delayed(Duration(milliseconds: delayMs));
      debugPrint('Delay completed: ${delayMs}ms for page ${widget.data.pageIndex}');
      
      // Dispose any existing controller first (important when switching between pages)
      if (_videoController != null) {
        debugPrint('⚠️ Disposing existing video controller before reinitializing');
        debugPrint('⚠️ Previous controller was for page: ${widget.data.pageIndex}');
        _chewieController?.dispose();
        _chewieController = null;
        _videoController!.removeListener(_videoListener);
        await _videoController!.pause();
        await _videoController!.dispose();
        _videoController = null;
      }
      
      // Also dispose chewie controller if it exists
      if (_chewieController != null) {
        debugPrint('⚠️ Disposing existing Chewie controller');
        _chewieController!.dispose();
        _chewieController = null;
      }
      
      // Create video controller with enhanced options for Android release
      // Asset path should match exactly what's in pubspec.yaml
      String assetPath = videoPath;
      debugPrint('Attempting to load asset: $assetPath');
      debugPrint('Page index: ${widget.data.pageIndex}');
      
      // CRITICAL: For 2nd splash screen, try multiple initialization attempts
      int maxRetries = widget.data.pageIndex == 1 ? 3 : 1;
      Exception? lastError;
      
      for (int attempt = 1; attempt <= maxRetries; attempt++) {
        try {
          debugPrint('🔄 Initialization attempt $attempt/$maxRetries for page ${widget.data.pageIndex}');
          
          _videoController = VideoPlayerController.asset(
            assetPath,
            videoPlayerOptions: VideoPlayerOptions(
              mixWithOthers: false, // Don't mix with other audio
              allowBackgroundPlayback: false,
            ),
          );
          
          debugPrint('✅ Video controller created successfully (attempt $attempt)');
          debugPrint('Asset path used: $assetPath');
          break; // Success, exit retry loop
          
        } catch (e) {
          lastError = e is Exception ? e : Exception(e.toString());
          debugPrint('❌ Attempt $attempt failed: $e');
          if (attempt < maxRetries) {
            debugPrint('⏳ Waiting before retry...');
            await Future.delayed(Duration(milliseconds: 200 * attempt));
            // Dispose failed controller
            try {
              await _videoController?.dispose();
            } catch (_) {}
            _videoController = null;
          }
        }
      }
      
      if (_videoController == null) {
        throw lastError ?? Exception('Failed to create video controller after $maxRetries attempts');
      }
      
      // Add listener to monitor video state changes
      _videoController!.addListener(_videoListener);
      
      debugPrint('Starting video initialization (SYNC mode for release)...');
      
      // CRITICAL FIX: Initialize with extended timeout for release builds
      // Release builds take longer to decode video on first load
      await _videoController!.initialize().timeout(
        const Duration(seconds: 30), // Increased from 20 to 30 seconds
        onTimeout: () {
          debugPrint('❌ Video initialization timeout after 30 seconds');
          debugPrint('This usually means:');
          debugPrint('1. Video codec is not supported (needs H.264)');
          debugPrint('2. Video file is corrupted');
          debugPrint('3. Asset not properly bundled in APK');
          throw Exception('Video initialization timeout - check video format');
        },
      );
      
      if (!mounted || _isDisposed) {
        debugPrint('❌ Widget not mounted or disposed after initialization');
        await _videoController!.dispose();
        return;
      }
      
      debugPrint('✅ Video initialized successfully');
      debugPrint('Video initialized: ${_videoController!.value.isInitialized}');
      debugPrint('Video duration: ${_videoController!.value.duration}');
      debugPrint('Video size: ${_videoController!.value.size}');
      debugPrint('Video aspect ratio: ${_videoController!.value.aspectRatio}');
      debugPrint('Video has error: ${_videoController!.value.hasError}');
      
      if (_videoController!.value.hasError) {
        final errorDesc = _videoController!.value.errorDescription ?? 'Unknown video error';
        debugPrint('❌ Video has error: $errorDesc');
        debugPrint('❌ Error details: ${_videoController!.value.toString()}');
        throw Exception('Video playback error: $errorDesc');
      }
      
      if (!_videoController!.value.isInitialized) {
        debugPrint('❌ Video not initialized properly');
        debugPrint('❌ Video state: ${_videoController!.value.toString()}');
        throw Exception('Video failed to initialize - file may not be a valid MP4 container');
      }
      
      // Create Chewie controller for better playback handling
      // Note: Muting is done via video controller volume, not Chewie parameter
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        looping: true,
        showControls: false, // No controls for splash screen
        allowFullScreen: false,
        allowMuting: false,
        allowPlaybackSpeedChanging: false,
        aspectRatio: _videoController!.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          debugPrint('Chewie error: $errorMessage');
          return Center(
            child: Text(
              'Video Error: $errorMessage',
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );
      
      debugPrint('✅ Chewie controller created successfully');
      
      // Configure video playback settings
      try {
        await _videoController!.setLooping(true);
        debugPrint('✅ Video looping enabled');
      } catch (e) {
        debugPrint('⚠️ Could not set looping: $e');
      }
      
      try {
        await _videoController!.setVolume(0.0); // Mute video for splash screen
        debugPrint('✅ Video muted');
      } catch (e) {
        debugPrint('⚠️ Could not set volume: $e');
      }
      
      // CRITICAL FIX: Ensure video starts playing immediately
      // Special retry logic for 2nd splash screen (pageIndex 1)
      if (widget.data.pageIndex == 1) {
        debugPrint('🎯 Special play handling for 2nd splash screen');
        bool playSuccess = false;
        for (int attempt = 1; attempt <= 5; attempt++) {
          try {
            debugPrint('🔄 Play attempt $attempt/5 for 2nd splash');
            await _videoController!.play();
            await Future.delayed(Duration(milliseconds: 300 + (attempt * 100)));
            
            if (_videoController!.value.isPlaying) {
              debugPrint('✅ Video started playing on attempt $attempt');
              playSuccess = true;
              break;
            } else {
              debugPrint('⚠️ Video not playing after attempt $attempt');
              if (attempt < 5) {
                await Future.delayed(Duration(milliseconds: 200 * attempt));
              }
            }
          } catch (e) {
            debugPrint('❌ Play attempt $attempt failed: $e');
            if (attempt < 5) {
              await Future.delayed(Duration(milliseconds: 200 * attempt));
            }
          }
        }
        
        if (!playSuccess) {
          debugPrint('❌ All play attempts failed for 2nd splash screen');
          // Don't throw - let it continue and show fallback
          debugPrint('⚠️ Will show fallback image for 2nd splash');
        }
      } else {
        // Standard play for 3rd splash screen
        try {
          await _videoController!.play();
          debugPrint('✅ Video play() called');
        } catch (e) {
          debugPrint('⚠️ Could not start playback: $e');
          throw Exception('Failed to start video playback: $e');
        }
        
        // Wait to verify video actually starts
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (!_videoController!.value.isPlaying) {
          debugPrint('⚠️ Warning: Video initialized but not playing');
          await _videoController!.play();
        }
      }
      
      debugPrint('Video playing: ${_videoController!.value.isPlaying}');
      debugPrint('Video position: ${_videoController!.value.position}');
      debugPrint('Video duration: ${_videoController!.value.duration}');
      
      if (mounted && !_isDisposed) {
        setState(() {
          _isVideoInitialized = true;
          _errorMessage = null;
        });
        debugPrint('✅ Video state updated - ready to display');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Video initialization FAILED');
      debugPrint('Error type: ${e.runtimeType}');
      debugPrint('Error message: $e');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('');
      debugPrint('🔍 TROUBLESHOOTING:');
      debugPrint('Video file: ${widget.data.imagePath}');
      debugPrint('Page index: ${widget.data.pageIndex}');
      debugPrint('');
      
      // Check if it's a source error (codec issue)
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('source error') || errorStr.contains('codec') || errorStr.contains('format')) {
        debugPrint('⚠️ DETECTED: Video codec/format issue');
        debugPrint('');
        debugPrint('Common causes:');
        debugPrint('1. Video uses unsupported codec (H.265/HEVC instead of H.264)');
        debugPrint('2. Video file is corrupted or incomplete');
        debugPrint('3. MP4 container structure is invalid');
        debugPrint('4. Audio codec not AAC');
        debugPrint('');
        debugPrint('✅ SOLUTION: Convert video to H.264/AAC format');
        debugPrint('1. Go to: https://cloudconvert.com/mp4-converter');
        debugPrint('2. Upload: ${widget.data.imagePath}');
        debugPrint('3. Settings:');
        debugPrint('   - Video Codec: H.264 (AVC)');
        debugPrint('   - Audio Codec: AAC');
        debugPrint('   - Resolution: 720p');
        debugPrint('   - Frame Rate: 30fps');
        debugPrint('4. Download and replace the file');
        debugPrint('5. Rebuild: flutter clean && flutter build apk --release');
      } else {
        debugPrint('Common issues:');
        debugPrint('1. Raw H.264 file renamed to .mp4 (NOT a valid MP4 container)');
        debugPrint('2. Video codec not H.264 (needs conversion)');
        debugPrint('3. Missing MP4 container structure (needs proper muxing)');
        debugPrint('4. File not bundled in assets');
        debugPrint('');
        debugPrint('SOLUTION: Convert using online tool:');
        debugPrint('https://cloudconvert.com/h264-to-mp4');
      }
      
      // Extract more specific error message
      String errorMsg = 'Video format not supported.';
      if (e.toString().contains('timeout')) {
        errorMsg = 'Video initialization timeout - file may be corrupted or invalid format.';
      } else if (e.toString().contains('codec') || e.toString().contains('format')) {
        errorMsg = 'Video codec/format not supported. Convert to H.264/AAC MP4.';
      } else if (e.toString().contains('container') || e.toString().contains('MP4')) {
        errorMsg = 'Invalid MP4 container. File needs proper MP4 muxing.';
      } else {
        errorMsg = 'Video failed to load: ${e.toString().split(':').last.trim()}';
      }
      
      if (mounted && !_isDisposed) {
        setState(() {
          _errorMessage = errorMsg;
          _isVideoInitialized = false;
        });
        // Clean up failed controller
        try {
          await _videoController?.dispose();
        } catch (disposeError) {
          debugPrint('Error disposing video controller: $disposeError');
        }
        _videoController = null;
      }
    }
  }

  void _videoListener() {
    if (!mounted) return;
    
    if (_videoController!.value.hasError) {
      setState(() {
        _errorMessage = _videoController!.value.errorDescription ?? 'Video error';
        _isVideoInitialized = false;
      });
    } else if (_videoController!.value.isInitialized && !_isVideoInitialized) {
      setState(() {
        _isVideoInitialized = true;
      });
    }
  }

  @override
  bool get wantKeepAlive => true; // Keep video players alive in PageView

  @override
  void dispose() {
    _isDisposed = true;
    _videoController?.removeListener(_videoListener);
    _chewieController?.dispose();
    _videoController?.pause();
    _videoController?.dispose();
    _firstScreenAnimationController?.dispose();
    // Dispose image animation controller if it was initialized
    _imageAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    // For 2nd (index 1) or 3rd (index 2) splash screen with video
    if ((widget.data.pageIndex == 1 || widget.data.pageIndex == 2) && 
        widget.data.imagePath.endsWith('.mp4')) {
      // If video failed or error occurred, show error message with fallback
      if (_errorMessage != null || (_videoController != null && _videoController!.value.hasError)) {
        debugPrint('Video error - showing fallback: $_errorMessage');
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: ThemeHelper.getBackgroundColor(context),
          child: Stack(
            children: [
              // Fallback image based on page index
              Image.asset(
                widget.data.pageIndex == 1 ? '2ndsplash screen.jpeg' : '3rd splashcsrren.jpeg',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  debugPrint('Error loading fallback image: $error');
                  return Container(
                    color: ThemeHelper.getBackgroundColor(context),
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 64,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
              // Error message overlay (only in debug mode)
              if (kDebugMode)
                Positioned(
                  bottom: 100,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '⚠️ Video Failed to Load',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Page ${widget.data.pageIndex + 1}: ${widget.data.imagePath}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _errorMessage ?? 'Convert video to H.264/AAC MP4 format',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Use: https://cloudconvert.com/h264-to-mp4',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      }
      
      // If video is initialized and ready, show it
      if (_isVideoInitialized && 
          _videoController != null && 
          _videoController!.value.isInitialized &&
          !_videoController!.value.hasError) {
        debugPrint('✅ Video playing successfully for page ${widget.data.pageIndex}');
        debugPrint('✅ Video file: ${widget.data.imagePath}');
        debugPrint('✅ Video playing: ${_videoController!.value.isPlaying}');
        debugPrint('✅ Chewie controller: ${_chewieController != null}');
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
              ? Chewie(controller: _chewieController!)
              : Center(
                  child: AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  ),
                ),
        );
      }
      
      // Video is still loading - show fallback image immediately instead of black screen
      return FutureBuilder(
        future: Future.delayed(const Duration(seconds: 10)),
        builder: (context, snapshot) {
          // Show fallback image while loading OR if timeout
          debugPrint('Video loading - showing fallback image for page ${widget.data.pageIndex}');
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: ThemeHelper.getBackgroundColor(context),
            child: Stack(
              children: [
                // Always show fallback image while loading
                Image.asset(
                  widget.data.pageIndex == 1 ? '2ndsplash screen.jpeg' : '3rd splashcsrren.jpeg',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('Error loading fallback image: $error');
                    return Container(
                      color: ThemeHelper.getBackgroundColor(context),
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
                // Show loading indicator overlay only if video is still initializing (not after timeout)
                if (snapshot.connectionState != ConnectionState.done)
                  Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                          if (kDebugMode) ...[
                            const SizedBox(height: 20),
                            Text(
                              'Loading video for page ${widget.data.pageIndex + 1}...',
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      );
    }

    // Note: 2nd splash screen (index 1) now uses video above, this section is kept for legacy/fallback

    // For other splash screens, show the normal layout
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hero image with subtle restaurant icon background
          Expanded(
            flex: 3,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Decorative restaurant icons in the background (aligned with dots)
                IgnorePointer(
                  child: Stack(
                    children: [
                      // Top row, left & right of chef
                      Positioned(
                        top: 40,
                        left: 60,
                        child: _iconBadge(
                          context,
                          icon: Icons.restaurant_menu,
                        ),
                      ),
                      Positioned(
                        top: 40,
                        right: 60,
                        child: _iconBadge(
                          context,
                          icon: Icons.local_pizza,
                        ),
                      ),
                      // Middle row, closer to chef shoulders
                      Positioned(
                        top: 140,
                        left: 40,
                        child: _iconBadge(
                          context,
                          icon: Icons.ramen_dining,
                        ),
                      ),
                      Positioned(
                        top: 140,
                        right: 40,
                        child: _iconBadge(
                          context,
                          icon: Icons.icecream,
                        ),
                      ),
                      // Bottom row
                      Positioned(
                        bottom: 30,
                        left: 80,
                        child: _iconBadge(
                          context,
                          icon: Icons.local_cafe,
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        right: 80,
                        child: _iconBadge(
                          context,
                          icon: Icons.local_dining,
                        ),
                      ),
                    ],
                  ),
                ),
                // Main chef / food image
                Center(
                  child: AnimatedImage(
                    imagePath: widget.data.imagePath,
                    height: MediaQuery.of(context).size.height * 0.35,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Headline with highlighted text (animated)
          widget.data.pageIndex == 0 && _headlineFadeAnimation != null && _headlineSlideAnimation != null
              ? FadeTransition(
                  opacity: _headlineFadeAnimation!,
                  child: SlideTransition(
                    position: _headlineSlideAnimation!,
                    child: _buildHeadline(context),
                  ),
                )
              : _buildHeadline(context),
          const SizedBox(height: 16),
          // Body text (animated)
          widget.data.pageIndex == 0 && _bodyFadeAnimation != null && _bodySlideAnimation != null
              ? FadeTransition(
                  opacity: _bodyFadeAnimation!,
                  child: SlideTransition(
                    position: _bodySlideAnimation!,
                    child: _buildBodyText(context),
                  ),
                )
              : _buildBodyText(context),
          const Spacer(flex: 1),
        ],
      ),
    );
  }

  /// Light orange restaurant icon with white background used behind the chef image.
  Widget _iconBadge(BuildContext context, {required IconData icon}) {
    return Container(
      width: 30,
      height: 30,
      // decoration: const BoxDecoration(
      //   shape: BoxShape.circle,
      //   color: Color.fromARGB(255, 246, 153, 100),
      // ),
      child: Icon(
        icon,
        size: 20,
        color: Color.fromARGB(255, 246, 153, 100),
      ),
    );
  }

  Widget _buildHeadline(BuildContext context) {
    return _buildRichText(
      context: context,
      text: widget.data.headline,
      highlightWords: widget.data.highlightWords,
      style: AppTextStyles.splashHeadline.copyWith(
        color: ThemeHelper.getTextPrimaryColor(context),
      ),
      highlightStyle: AppTextStyles.splashHeadlineHighlight,
    );
  }

  Widget _buildBodyText(BuildContext context) {
    return Text(
      widget.data.bodyText,
      textAlign: TextAlign.center,
      style: AppTextStyles.splashBody.copyWith(
        color: ThemeHelper.getTextSecondaryColor(context),
      ),
    );
  }

  /// Builds a RichText widget with highlighted words
  Widget _buildRichText({
    required String text,
    required List<String> highlightWords,
    required TextStyle style,
    required TextStyle highlightStyle,
    required BuildContext context,
  }) {
    List<TextSpan> spans = [];
    String remainingText = text;

    // Sort highlight words by position in text (longest first to avoid partial matches)
    List<String> sortedHighlights = List.from(highlightWords)
      ..sort((a, b) => b.length.compareTo(a.length));

    int currentIndex = 0;

    while (currentIndex < remainingText.length) {
      int? nextHighlightIndex;
      String? nextHighlight;

      // Find the earliest highlight word
      for (String highlight in sortedHighlights) {
        int index = remainingText
            .toLowerCase()
            .indexOf(highlight.toLowerCase(), currentIndex);
        if (index != -1 &&
            (nextHighlightIndex == null || index < nextHighlightIndex)) {
          nextHighlightIndex = index;
          nextHighlight = highlight;
        }
      }

      if (nextHighlightIndex != null && nextHighlight != null) {
        // Add text before highlight
        if (nextHighlightIndex > currentIndex) {
          spans.add(
            TextSpan(
              text: remainingText.substring(currentIndex, nextHighlightIndex),
              style: style,
            ),
          );
        }

        // Add highlighted text
        spans.add(
          TextSpan(
            text: remainingText.substring(
              nextHighlightIndex,
              nextHighlightIndex + nextHighlight.length,
            ),
            style: highlightStyle,
          ),
        );

        currentIndex = nextHighlightIndex + nextHighlight.length;
      } else {
        // Add remaining text
        spans.add(
          TextSpan(
            text: remainingText.substring(currentIndex),
            style: style,
          ),
        );
        break;
      }
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: spans),
    );
  }
}

