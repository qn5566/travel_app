import 'package:flutter/material.dart';

import '../../config/global_config.dart';
import '../network_cache_image.dart';
import '../tech_loading_view.dart';

/// 「封面圖」
class VideoCoverView extends StatelessWidget {
  final String? cover;
  final String? money;
  final double radius;

  String get moneyText => money == '0' ? '' : money ?? '';

  const VideoCoverView({super.key, this.cover, this.money, this.radius = 0});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
        final cacheWidth = _cacheSize(constraints.maxWidth, devicePixelRatio);
        final cacheHeight = _cacheSize(constraints.maxHeight, devicePixelRatio);

        return Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: NetworkCacheImage(
                  url: cover ?? '',
                  width: double.infinity,
                  height: double.infinity,
                  radius: radius,
                  fit: BoxFit.cover,
                  memCacheWidth: cacheWidth,
                  memCacheHeight: cacheHeight,
                  placeholderWidget: const TechCoverPlaceholder(),
                  errorWidget: const Icon(Icons.error),
                  placeholder: Image.asset(
                    getRandomErrorImagePath(),
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int? _cacheSize(double value, double devicePixelRatio) {
    if (!value.isFinite || value <= 0) return null;
    final size = (value * devicePixelRatio).round();
    return size > 0 ? size : null;
  }
}
