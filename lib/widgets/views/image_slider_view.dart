import 'package:flutter/material.dart';

import '../../config/global_config.dart';
import '../network_cache_image.dart';
import '../tech_loading_view.dart';

const _techCyan = Color(0xFF55E6FF);
const _techTextPrimary = Color(0xFFEAF3FF);

/// 「多圖滑動」封面：景點有多張圖片時可橫向滑動瀏覽，
/// 並套用圓角卡片、邊框與陰影、底部漸層、地區標籤與膠囊指示器。
/// 只有一張（或沒有）圖片時顯示單張、無指示器。
class ImageSliderView extends StatefulWidget {
  final List<String> urls;
  final String? money;
  final double radius;

  const ImageSliderView({
    super.key,
    required this.urls,
    this.money,
    this.radius = 24,
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

  Widget _buildImage(String url) {
    return NetworkCacheImage(
      url: url,
      width: double.infinity,
      height: double.infinity,
      radius: widget.radius,
      fit: BoxFit.contain,
      placeholderWidget: const TechCoverPlaceholder(),
      errorWidget: const Icon(Icons.error),
      placeholder: Image.asset(
        getRandomErrorImagePath(),
        fit: BoxFit.contain,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final covers = widget.urls.isEmpty ? const <String>[''] : widget.urls;
    final region = (widget.money ?? '').trim();

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF0C1327),
        borderRadius: BorderRadius.circular(widget.radius),
        border: Border.all(color: _techCyan.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: _techCyan.withValues(alpha: 0.14),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
          const BoxShadow(
            color: Color(0x55000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (covers.length > 1)
            PageView.builder(
              controller: _pageController,
              itemCount: covers.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildImage(covers[index]);
              },
            )
          else
            _buildImage(covers.first),
          const IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.55, 1.0],
                  colors: [Colors.transparent, Color(0x66000000)],
                ),
              ),
            ),
          ),
          if (region.isNotEmpty)
            Positioned(
              left: 14,
              top: 14,
              child: _RegionChip(region: region),
            ),
          if (covers.length > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: 14,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(covers.length, (index) {
                  final selected = index == _currentIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: selected ? 18 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color:
                          Colors.white.withValues(alpha: selected ? 1.0 : 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

class _RegionChip extends StatelessWidget {
  const _RegionChip({required this.region});

  final String region;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xE60C1327),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _techCyan.withValues(alpha: 0.7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.place_outlined,
            size: 14,
            color: _techCyan,
          ),
          const SizedBox(width: 4),
          Text(
            region,
            style: const TextStyle(
              color: _techTextPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              fontFamily: "PingFangSC",
            ),
          ),
        ],
      ),
    );
  }
}
