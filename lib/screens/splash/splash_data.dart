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
      headline: 'Explore Our Delicious Restaurant Menu',
      highlightWords: ['Delicious Restaurant'],
      bodyText:
          'Discover a wide variety of mouth-watering dishes prepared with fresh ingredients and authentic flavors.',
    ),
    SplashData(
      pageIndex: 1,
      imagePath: 'noodles-with-seafood-2026-01-05-05-04-44-utc-removebg-preview.png',
      headline: 'Fast and Reliable Food Delivery to Your Doorstep',
      highlightWords: ['Fast', 'Reliable'],
      bodyText:
          'Get your favorite meals delivered hot and fresh. We ensure quality food reaches you quickly and safely.',
    ),
    SplashData(
      pageIndex: 2,
      imagePath:
          'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80&fm=jpg',
      headline: 'Order Smart with Best Prices and Offers',
      highlightWords: ['Best Prices'],
      bodyText:
          'Enjoy exclusive deals and discounts on your favorite dishes. Save more with our special offers and loyalty rewards.',
    ),
  ];

  static int get totalScreens => splashScreens.length;
}

