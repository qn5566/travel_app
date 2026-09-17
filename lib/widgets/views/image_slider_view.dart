import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../config/global_config.dart';
import '../network_cache_image.dart';

/// 「多圖滑動」封面：景點有多張圖片時可橫向滑動瀏覽，
/// 右下角顯示圓點指示器；只有一張（或沒有）圖片時行為與
/// [VideoCoverView] 相同（顯示單張、無指示器）。
class ImageSliderView extends StatefulWidget {
  final List<String> urls;
  final String? money;
  final double radius;

  const ImageSliderView({
    super.key,
    required this.urls,
    this.money,
    this.radius = 0,
  });

  @override
  State<ImageSliderView> createState() => _ImageSliderViewState();
}

class _ImageSliderViewState extends State<ImageSliderView> {
  PageController? _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(covariant ImageSliderView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.urls.length != widget.urls.length ||
        _currentIndex >= widget.urls.length) {
      _initController();
    }
  }

  void _initController() {
    _pageController?.dispose();
    _currentIndex = 0;
    _pageController = widget.urls.length > 1 ? PageController() : null;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  /// 與 [VideoCoverView] 相同的單張圖片（placeholder / error 處理一致）
  Widget _buildImage(String url) {
    return NetworkCacheImage(
      url: url,
      width: double.infinity,
      height: double.infinity,
      radius: widget.radius,
      fit: BoxFit.cover,
      placeholderWidget: Lottie.asset('assets/cover.json'),
      errorWidget: const Icon(Icons.error),
      placeholder: Image.asset(
        getRandomErrorImagePath(),
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.urls.isEmpty) {
      // 沒有任何圖片：顯示 placeholder（與 VideoCoverView 傳空字串時一致）
      return _buildImage('');
    }
    if (widget.urls.length == 1) {
      return _buildImage(widget.urls.first);
    }

    return Stack(
      children: [
        Positioned.fill(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.urls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildImage(widget.urls[index]);
            },
          ),
        ),
        // 圓點指示器（右下角）
        Positioned(
          right: 12,
          bottom: 60,
          child: _buildIndicator(context),
        ),
      ],
    );
  }

  Widget _buildIndicator(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          widget.urls.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: _currentIndex == index ? 7 : 5,
            height: _currentIndex == index ? 7 : 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(
                  alpha: _currentIndex == index ? 1.0 : 0.5),
            ),
          ),
        ),
      ),
    );
  }
}
