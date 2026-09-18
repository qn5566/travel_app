import 'package:flutter/material.dart';

/// 錯誤顯示的View
class CommentError extends StatelessWidget {
  const CommentError({super.key, this.textColor = Colors.black});

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _TechEmptyGraphic(),
        const SizedBox(height: 8),
        Text(
          '無資料',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

/// 無資料的科技感空狀態圖示
class _TechEmptyGraphic extends StatelessWidget {
  const _TechEmptyGraphic();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B3A5C), Color(0xFF10182E)],
        ),
        borderRadius: BorderRadius.circular(18),
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
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0x2255E6FF),
              border: Border.all(color: const Color(0x6655E6FF)),
            ),
            child: const Icon(
              Icons.search_off_rounded,
              color: Color(0xFF8CF3FF),
              size: 24,
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

    const inset = 6.0;
    const len = 12.0;

    void corner(Offset start, Offset pivot, Offset end) {
      canvas.drawLine(start, pivot, paint);
      canvas.drawLine(pivot, end, paint);
    }

    corner(
      const Offset(inset, inset + len),
      const Offset(inset, inset),
      const Offset(inset + len, inset),
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
