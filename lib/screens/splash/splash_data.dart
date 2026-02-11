/// Data model for splash screen content
class SplashData {
  final String imagePath;
  final String headline;
  final List<String> highlightWords; // Words to highlight in headline
  final String bodyText;
  final int pageIndex;

  const SplashData({
    required this.imagePath,
    required this.headline,
    required this.highlightWords,
    required this.bodyText,
    required this.pageIndex,
  });
}

/// Collection of all splash screen data
class SplashScreenData {
  static final List<SplashData> splashScreens = [
    SplashData(
      pageIndex: 0,
      imagePath: 'handsome-chef-with-closed-eyes-holding-pan-and-cap-2026-01-05-23-55-08-utc-removebg-preview.png',
      headline: 'How Our App Works - Browse & Select',
      highlightWords: ['Browse & Select'],
      bodyText:
          'Browse through our extensive menu, explore categories, and select your favorite dishes. Add items to your cart with just a tap.',
    ),
    SplashData(
      pageIndex: 1,
      imagePath: '2ndsplashvedio.mp4',
      headline: '',
      highlightWords: [],
      bodyText: '',
    ),
    SplashData(
      pageIndex: 2,
      imagePath: 'splash_video.mp4',
      headline: '',
      highlightWords: [],
      bodyText: '',
    ),
  ];

  static int get totalScreens => splashScreens.length;
}

