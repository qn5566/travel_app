import 'dart:ui';

import 'package:flutter/material.dart';

/// Glass-morphism circular icon button used in the detail page app bar.
class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 38,
    this.iconSize = 20,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xD9162940), Color(0xD90C1327)],
              ),
              borderRadius: BorderRadius.circular(size / 2),
              border: Border.all(color: const Color(0x6655E6FF)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x44000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: const Color(0xFF8CF3FF), size: iconSize),
          ),
        ),
      ),
    );
  }
}

/// Gradient pill-shaped button for the detail page action (加入/刪除想去名單).
class GradientPillButton extends StatelessWidget {
  const GradientPillButton({
    super.key,
    required this.text,
    this.isDelete = false,
    required this.onTap,
  });

  final String text;
  final bool isDelete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = isDelete ? const Color(0xFFFF5C8A) : const Color(0xFF55E6FF);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDelete
                ? [const Color(0xFF8B1A3B), const Color(0xFF4A0E2A)]
                : [const Color(0xFF19687B), const Color(0xFF49368C)],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accent.withOpacity(0.55)),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.18),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isDelete ? Icons.delete_outline_rounded : Icons.favorite_rounded,
              color: Colors.white,
              size: 15,
            ),
            const SizedBox(width: 5),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                fontFamily: "PingFangSC",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Rounded card container for info rows in [InfoView].
class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
    this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final Widget child;
  final VoidCallback? onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8E6E4)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: (iconColor ?? const Color(0xFF49368C)).withOpacity(0.10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 17,
                color: iconColor ?? const Color(0xFF49368C),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF7C7474),
                      fontWeight: FontWeight.w600,
                      fontFamily: "PingFangSC",
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  child,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A styled title text for info sections.
class InfoText extends StatelessWidget {
  const InfoText(this.text, {super.key, this.isLink = false});

  final String text;
  final bool isLink;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: isLink ? Colors.blue : const Color(0xFF3A3A3A),
        fontWeight: isLink ? FontWeight.w600 : FontWeight.normal,
        fontFamily: "PingFangSC",
        fontSize: 13,
        height: 1.5,
        decoration: isLink ? TextDecoration.underline : TextDecoration.none,
        decorationColor: Colors.blue,
      ),
    );
  }
}

/// Empty state widget for comment view.
class CommentEmptyState extends StatelessWidget {
  const CommentEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 48,
              color: const Color(0xFF49368C).withOpacity(0.35),
            ),
            const SizedBox(height: 12),
            const Text(
              '暫無評論，快來搶沙發！',
              style: TextStyle(
                color: Color(0xFFB0B0B0),
                fontSize: 14,
                fontFamily: "PingFangSC",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
