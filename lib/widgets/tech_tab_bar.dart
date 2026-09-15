import 'dart:ui';

import 'package:flutter/material.dart';

class TechTabBar extends StatelessWidget {
  const TechTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<_TechTabItem> _items = [
    _TechTabItem(Icons.near_me_rounded, '附近'),
    _TechTabItem(Icons.landscape_rounded, '景點'),
    _TechTabItem(Icons.favorite_rounded, '想要去'),
    _TechTabItem(Icons.history_rounded, '歷史'),
    _TechTabItem(Icons.chat_bubble_outline_rounded, '留言板'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xE6132034),
                  const Color(0xE60D1027),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0x6655E6FF)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x66000000),
                  blurRadius: 22,
                  offset: Offset(0, 9),
                ),
                BoxShadow(
                  color: Color(0x2255E6FF),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth / _items.length;
                return Row(
                  children: List.generate(_items.length, (index) {
                    final item = _items[index];
                    final selected = currentIndex == index;
                    return SizedBox(
                      width: itemWidth,
                      child: Semantics(
                        button: true,
                        selected: selected,
                        label: item.label,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onTap(index),
                          child: Center(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 260),
                              curve: Curves.easeOutCubic,
                              padding: EdgeInsets.symmetric(
                                horizontal: selected ? 11 : 8,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                gradient: selected
                                    ? const LinearGradient(
                                        colors: [
                                          Color(0xFF1B6074),
                                          Color(0xFF3D2C7A),
                                        ],
                                      )
                                    : null,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: selected
                                      ? const Color(0xFF55E6FF)
                                      : Colors.transparent,
                                  width: 1,
                                ),
                                boxShadow: selected
                                    ? const [
                                        BoxShadow(
                                          color: Color(0x8855E6FF),
                                          blurRadius: 12,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: AnimatedScale(
                                scale: selected ? 1.04 : 1,
                                duration: const Duration(milliseconds: 260),
                                curve: Curves.easeOutBack,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      item.icon,
                                      size: selected ? 22 : 20,
                                      color: selected
                                          ? const Color(0xFFBDF8FF)
                                          : Colors.white.withOpacity(0.72),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      item.label,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: selected
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.62),
                                        fontSize: 10,
                                        fontWeight: selected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        letterSpacing: 0.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _TechTabItem {
  const _TechTabItem(this.icon, this.label);

  final IconData icon;
  final String label;
}
