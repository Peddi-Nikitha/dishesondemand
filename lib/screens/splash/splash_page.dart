import 'package:flutter/material.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/animated_image.dart';
import 'splash_data.dart';

/// Individual splash page widget with animated image, headline, and body text
class SplashPage extends StatelessWidget {
  final SplashData data;

  const SplashPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Image
          Expanded(
            flex: 3,
            child: Center(
              child: AnimatedImage(
                imagePath: data.imagePath,
                height: MediaQuery.of(context).size.height * 0.35,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Headline with highlighted text
          _buildHeadline(context),
          const SizedBox(height: 16),
          // Body text
          _buildBodyText(context),
          const Spacer(flex: 1),
        ],
      ),
    );
  }

  Widget _buildHeadline(BuildContext context) {
    return _buildRichText(
      context: context,
      text: data.headline,
      highlightWords: data.highlightWords,
      style: AppTextStyles.splashHeadline.copyWith(
        color: ThemeHelper.getTextPrimaryColor(context),
      ),
      highlightStyle: AppTextStyles.splashHeadlineHighlight,
    );
  }

  Widget _buildBodyText(BuildContext context) {
    return Text(
      data.bodyText,
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

