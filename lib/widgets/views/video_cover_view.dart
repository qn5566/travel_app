import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../network_cache_image.dart';

/// 「封面圖」
class VideoCoverView extends StatelessWidget {
  final String? cover;
  final String? money;
  final double radius;

  String get moneyText => money == '0' ? '' : money ?? '';

  const VideoCoverView({super.key, this.cover, this.money, this.radius = 0});

  @override
  Widget build(BuildContext context) {
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
              placeholderWidget: Lottie.asset('assets/cover.json'),
              errorWidget: const Icon(Icons.error),
              placeholder: const Icon(Icons.error),
            ),
          ),
        ],
      ),
    );
  }
}
