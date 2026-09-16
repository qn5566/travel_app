import 'dart:ui';

import 'package:flutter/material.dart';

class TechMapControls extends StatelessWidget {
  const TechMapControls({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.markerCount,
    required this.onLocate,
    required this.onRefresh,
    this.bannerAdWidget,
  });

  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final int markerCount;
  final VoidCallback onLocate;
  final VoidCallback onRefresh;
  final Widget? bannerAdWidget;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 14,
            right: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _GlassPanel(
                  borderRadius: 20,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 13,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 34,
                          width: 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF55E6FF).withOpacity(0.14),
                            border: Border.all(
                              color: const Color(0xFF55E6FF).withOpacity(0.72),
                            ),
                          ),
                          child: const Icon(
                            Icons.radar_rounded,
                            color: Color(0xFF8CF3FF),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'NEARBY EXPLORER',
                                style: TextStyle(
                                  color: Color(0xFFBDF8FF),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.7,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '已偵測到 $markerCount 個附近地點',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.76),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.wifi_tethering_rounded,
                          color: Color(0xFF9B7BFF),
                          size: 21,
                        ),
                      ],
                    ),
                  ),
                ),
                if (bannerAdWidget != null) ...[
                  const SizedBox(height: 8),
                  Align(alignment: Alignment.center, child: bannerAdWidget),
                ],
                const SizedBox(height: 10),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final selected = category == selectedCategory;
                      return Semantics(
                        button: true,
                        selected: selected,
                        label: '$category 分類',
                        child: GestureDetector(
                          onTap: () => onCategorySelected(category),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOutCubic,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              gradient: selected
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF19687B),
                                        Color(0xFF49368C),
                                      ],
                                    )
                                  : null,
                              color: selected
                                  ? null
                                  : const Color(0xD9101C32),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFF55E6FF)
                                    : Colors.white.withOpacity(0.2),
                              ),
                              boxShadow: selected
                                  ? const [
                                      BoxShadow(
                                        color: Color(0x8855E6FF),
                                        blurRadius: 12,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                category,
                                style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.75),
                                  fontSize: 12,
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 14,
            bottom: 106,
            child: _GlassPanel(
              borderRadius: 18,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Tooltip(
                    message: '定位目前位置',
                    child: IconButton(
                      onPressed: onLocate,
                      icon: const Icon(Icons.my_location_rounded),
                      color: const Color(0xFF8CF3FF),
                    ),
                  ),
                  Container(
                    height: 1,
                    width: 28,
                    color: Colors.white.withOpacity(0.18),
                  ),
                  Tooltip(
                    message: '更新附近資料',
                    child: IconButton(
                      onPressed: onRefresh,
                      icon: const Icon(Icons.radar_rounded),
                      color: const Color(0xFFB8A4FF),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 18,
            bottom: 103,
            child: IgnorePointer(
              child: Text(
                'SCANNING NEARBY LOCATIONS',
                style: TextStyle(
                  color: const Color(0xFFBDF8FF).withOpacity(0.82),
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                  shadows: const [Shadow(color: Colors.black, blurRadius: 6)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  const _GlassPanel({required this.borderRadius, required this.child});

  final double borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xD9162940), Color(0xD90C1327)],
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: const Color(0x6655E6FF)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 18,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
