import 'package:flutter/material.dart';

/// 科技感靜態載入占位圖，取代 Lottie 動畫以降低裝置負擔。
class TechLoadingView extends StatelessWidget {
  const TechLoadingView({
    super.key,
    this.compact = false,
    this.showLabel = true,
  });

  /// 小型占位（如列表內廣告欄位）
  final bool compact;

  /// 是否顯示「載入中」文字
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return const _TechLoadingGraphic(size: 40);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _TechLoadingGraphic(size: 84),
        if (showLabel) ...[
          const SizedBox(height: 14),
          Text(
            '載入中...',
            style: TextStyle(
              color: const Color(0xFF8CF3FF).withValues(alpha: 0.9),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'PingFangSC',
              letterSpacing: 1.5,
            ),
          ),
        ],
      ],
    );
  }
}

/// HUD 邊框 + 中心圖示的靜態圖形，與 app 青色霓虹主題一致。
class _TechLoadingGraphic extends StatelessWidget {
  const _TechLoadingGraphic({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B3A5C), Color(0xFF10182E)],
        ),
        borderRadius: BorderRadius.circular(size * 0.2),
        border: Border.all(color: const Color(0x9955E6FF), width: 1.2),
        boxShadow: const [
          BoxShadow(color: Color(0x3355E6FF), blurRadius: 16, spreadRadius: 2),
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const CustomPaint(
            size: Size.infinite,
            painter: _HudGridPainter(),
          ),
          Container(
            width: size * 0.55,
            height: size * 0.55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0x2255E6FF),
              border: Border.all(color: const Color(0x6655E6FF)),
            ),
            child: Icon(
              Icons.travel_explore_rounded,
              color: const Color(0xFF8CF3FF),
              size: size * 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _HudGridPainter extends CustomPainter {
  const _HudGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xAA55E6FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    final inset = size.width * 0.08;
    final len = size.width * 0.16;

    void corner(Offset start, Offset pivot, Offset end) {
      canvas.drawLine(start, pivot, paint);
      canvas.drawLine(pivot, end, paint);
    }

    corner(
      Offset(inset, inset + len),
      Offset(inset, inset),
      Offset(inset + len, inset),
    );
    corner(
      Offset(size.width - inset - len, inset),
      Offset(size.width - inset, inset),
      Offset(size.width - inset, inset + len),
    );
    corner(
      Offset(size.width - inset, size.height - inset - len),
      Offset(size.width - inset, size.height - inset),
      Offset(size.width - inset - len, size.height - inset),
    );
    corner(
      Offset(inset + len, size.height - inset),
      Offset(inset, size.height - inset),
      Offset(inset, size.height - inset - len),
    );

    final thinPaint = Paint()
      ..color = const Color(0x2E55E6FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      thinPaint,
    );
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      thinPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 封面圖載入時的靜態科技感占位（取代 Lottie cover.json 動畫）。
class TechCoverPlaceholder extends StatelessWidget {
  const TechCoverPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B3A5C), Color(0xFF10182E)],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const CustomPaint(
            size: Size.infinite,
            painter: _HudGridPainter(),
          ),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0x2255E6FF),
              border: Border.all(color: const Color(0x6655E6FF)),
            ),
            child: const Icon(
              Icons.travel_explore_rounded,
              color: Color(0xFF8CF3FF),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
