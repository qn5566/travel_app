import 'dart:ui';

import 'package:flutter/material.dart';

const _techCyan = Color(0xFF55E6FF);
const _techViolet = Color(0xFF7C5CFF);
const _techTextPrimary = Color(0xFFEAF3FF);
const _techTextSecondary = Color(0xFF8FA3B8);
const _techTextMuted = Color(0xFF64748B);

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
    this.icon,
    this.showText = true,
    required this.onTap,
  });

  final String text;
  final bool isDelete;
  final IconData? icon;
  final bool showText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = isDelete ? const Color(0xFFFF5C8A) : const Color(0xFF55E6FF);
    final iconWidget = Icon(
      icon ??
          (isDelete ? Icons.delete_outline_rounded : Icons.favorite_rounded),
      color: Colors.white,
      size: showText ? 15 : 18,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: showText
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
            : const EdgeInsets.all(9),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDelete
                ? [const Color(0xFF8B1A3B), const Color(0xFF4A0E2A)]
                : [const Color(0xFF19687B), const Color(0xFF49368C)],
          ),
          borderRadius: BorderRadius.circular(showText ? 12 : 14),
          border: Border.all(color: accent.withOpacity(0.55)),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.18),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: showText
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  iconWidget,
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
              )
            : Center(child: iconWidget),
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
    final accent = iconColor ?? _techCyan;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xE61B2E52), Color(0xE60D1730)],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: accent.withValues(alpha: 0.30)),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.16),
              blurRadius: 16,
              offset: const Offset(0, 5),
            ),
            const BoxShadow(
              color: Color(0x33000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [accent, _techViolet],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.32),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 20,
                color: Colors.white,
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
                      color: _techTextSecondary,
                      fontWeight: FontWeight.w600,
                      fontFamily: "PingFangSC",
                      fontSize: 12,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 5),
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
        color: isLink ? _techCyan : _techTextPrimary,
        fontWeight: isLink ? FontWeight.w600 : FontWeight.normal,
        fontFamily: "PingFangSC",
        fontSize: 13.5,
        height: 1.55,
        decoration: isLink ? TextDecoration.underline : TextDecoration.none,
        decorationColor: _techCyan,
      ),
    );
  }
}

/// Empty state widget for comment view.
class CommentEmptyState extends StatelessWidget {
  const CommentEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    // 可用高度不足時（小螢幕、鍵盤開啟、大標題展開等）改為可捲動，避免 RenderFlex overflow
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 48,
                  color: _techCyan.withValues(alpha: 0.45),
                ),
                const SizedBox(height: 12),
                const Text(
                  '暫無評論，快來搶沙發！',
                  style: TextStyle(
                    color: _techTextMuted,
                    fontSize: 14,
                    fontFamily: "PingFangSC",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
