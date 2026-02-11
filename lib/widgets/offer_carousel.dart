import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'offer_banner.dart';

/// Carousel widget for offer banners with auto-scroll
class OfferCarousel extends StatefulWidget {
  final List<Map<String, String>> banners;
  final Function(String)? onButtonTap;

  const OfferCarousel({
    super.key,
    required this.banners,
    this.onButtonTap,
  });

  @override
  State<OfferCarousel> createState() => _OfferCarouselState();
}

class _OfferCarouselState extends State<OfferCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _timer;
  bool _isUserScrolling = false;
  DateTime? _lastUserInteraction;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Start auto-scroll after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    // Start with a small delay to ensure PageController is ready
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        
        // Check if user recently interacted (within last 2 seconds)
        if (_lastUserInteraction != null) {
          final timeSinceInteraction = DateTime.now().difference(_lastUserInteraction!);
          if (timeSinceInteraction.inSeconds < 2) {
            return; // Skip auto-scroll if user recently interacted
          }
        }

        if (_pageController.hasClients && !_isUserScrolling) {
          final nextIndex = _currentIndex < widget.banners.length - 1 
              ? _currentIndex + 1 
              : 0;
          
          _pageController.animateToPage(
            nextIndex,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      });
    });
  }

  void _onPageChanged(int index) {
    if (mounted) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _onPageScrollStart() {
    _isUserScrolling = true;
    _lastUserInteraction = DateTime.now();
  }

  void _onPageScrollEnd() {
    _isUserScrolling = false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: GestureDetector(
            onPanStart: (_) => _onPageScrollStart(),
            onPanEnd: (_) {
              Future.delayed(const Duration(milliseconds: 500), () {
                _onPageScrollEnd();
              });
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollStartNotification) {
                  _onPageScrollStart();
                } else if (notification is ScrollEndNotification) {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    _onPageScrollEnd();
                  });
                }
                return false;
              },
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: widget.banners.length,
                itemBuilder: (context, index) {
                  final banner = widget.banners[index];
                  return OfferBanner(
                    title: banner['title'] ?? '',
                    description: banner['description'] ?? '',
                    buttonText: banner['buttonText'] ?? 'Shop Now',
                    illustrationUrl: banner['illustrationUrl'] ?? '',
                    currentIndex: _currentIndex,
                    totalIndicators: widget.banners.length,
                    onButtonTap: widget.onButtonTap,
                    productSearchTerm: banner['productSearchTerm'],
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacingS),
        CarouselIndicator(
          currentIndex: _currentIndex,
          totalIndicators: widget.banners.length,
        ),
      ],
    );
  }
}

