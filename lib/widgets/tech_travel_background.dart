import 'dart:math';

import 'package:flutter/material.dart';

/// Original armor-inspired HUD background for content overlays.
class TechTravelBackground extends StatelessWidget {
  const TechTravelBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: CustomPaint(painter: _ArmorHudPainter()),
    );
  }
}

class _ArmorHudPainter extends CustomPainter {
  const _ArmorHudPainter();

  static const _ember = Color(0xFFFF633D);
  static const _cyan = Color(0xFF60E8FF);
  static const _steel = Color(0xFF1D2632);

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF070A10), Color(0xFF171B24), Color(0xFF090B10)],
          stops: [0, 0.52, 1],
        ).createShader(bounds),
    );

    _drawHexGrid(canvas, size);
    _drawArmorPanels(canvas, size);
    _drawCenterReactor(canvas, size);
    _drawHudCorners(canvas, size);
    _drawCircuitRoutes(canvas, size);
    _drawScanLines(canvas, size);
    _drawRivets(canvas, size);
  }

  void _drawHexGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _cyan.withOpacity(0.055)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;
    const radius = 24.0;
    const columnStep = radius * 1.5;
    const rowStep = radius * 1.72;
    for (double x = -radius; x < size.width + radius; x += columnStep) {
      final odd = ((x / columnStep).floor() & 1) == 1;
      for (double y = odd ? -rowStep * .5 : 0;
          y < size.height + rowStep;
          y += rowStep) {
        _drawHexagon(canvas, Offset(x, y), radius, paint);
      }
    }
  }

  void _drawArmorPanels(Canvas canvas, Size size) {
    final leftPanel = Path()
      ..moveTo(0, size.height * 0.04)
      ..lineTo(size.width * 0.27, 0)
      ..lineTo(size.width * 0.35, size.height * 0.20)
      ..lineTo(size.width * 0.26, size.height * 0.46)
      ..lineTo(size.width * 0.35, size.height * 0.74)
      ..lineTo(size.width * 0.20, size.height)
      ..lineTo(0, size.height)
      ..close();
    final rightPanel = Path()
      ..moveTo(size.width, size.height * 0.04)
      ..lineTo(size.width * 0.73, 0)
      ..lineTo(size.width * 0.65, size.height * 0.20)
      ..lineTo(size.width * 0.74, size.height * 0.46)
      ..lineTo(size.width * 0.65, size.height * 0.74)
      ..lineTo(size.width * 0.80, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    final panelPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [_steel.withOpacity(0.92), const Color(0xFF080B11)],
      ).createShader(Offset.zero & size);
    final seamPaint = Paint()
      ..color = const Color(0xFF9DA9B7).withOpacity(0.26)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    canvas.drawPath(leftPanel, panelPaint);
    canvas.drawPath(rightPanel, panelPaint);
    canvas.drawPath(leftPanel, seamPaint);
    canvas.drawPath(rightPanel, seamPaint);

    final insetPaint = Paint()
      ..color = Colors.black.withOpacity(0.34)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7;
    canvas.drawLine(
      Offset(size.width * 0.12, size.height * 0.12),
      Offset(size.width * 0.25, size.height * 0.88),
      insetPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.88, size.height * 0.12),
      Offset(size.width * 0.75, size.height * 0.88),
      insetPaint,
    );

    _drawWarningStripe(canvas, size, true);
    _drawWarningStripe(canvas, size, false);
  }

  void _drawWarningStripe(Canvas canvas, Size size, bool left) {
    final baseX = left ? size.width * 0.03 : size.width * 0.88;
    final paint = Paint()
      ..color = _ember.withOpacity(0.36)
      ..strokeWidth = 2;
    for (var index = 0; index < 9; index++) {
      final y = size.height * 0.14 + index * size.height * 0.075;
      final delta = left ? 16.0 : -16.0;
      canvas.drawLine(Offset(baseX, y), Offset(baseX + delta, y + 12), paint);
    }
  }

  void _drawCenterReactor(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.48);
    final radius = min(size.width, size.height) * 0.18;
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [_ember.withOpacity(0.30), _ember.withOpacity(0)],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 2.4));
    canvas.drawCircle(center, radius * 2.4, glow);

    final outer = Paint()
      ..color = const Color(0xFF56616E).withOpacity(0.58)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final inner = Paint()
      ..color = _ember.withOpacity(0.86)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, outer);
    canvas.drawCircle(center, radius * .72, inner);
    canvas.drawCircle(
      center,
      radius * .43,
      Paint()
        ..shader = RadialGradient(
          colors: [const Color(0xFFFFD1A3), _ember, const Color(0xFF7B1716)],
        ).createShader(Rect.fromCircle(center: center, radius: radius * .43)),
    );
    canvas.drawCircle(center, radius * .16, Paint()..color = const Color(0xFFFFF3D8));

    for (var index = 0; index < 12; index++) {
      final angle = index * pi / 6;
      final start = center + Offset(cos(angle), sin(angle)) * radius * 1.08;
      final end = center + Offset(cos(angle), sin(angle)) * radius * 1.25;
      canvas.drawLine(start, end, outer..strokeWidth = index.isEven ? 3 : 1);
    }
  }

  void _drawHudCorners(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _cyan.withOpacity(0.72)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    const length = 28.0;
    const inset = 18.0;
    final corners = [
      Offset(inset, inset),
      Offset(size.width - inset, inset),
      Offset(inset, size.height - inset),
      Offset(size.width - inset, size.height - inset),
    ];
    for (var index = 0; index < corners.length; index++) {
      final point = corners[index];
      final horizontal = index.isEven ? 1.0 : -1.0;
      final vertical = index < 2 ? 1.0 : -1.0;
      canvas.drawLine(point, point + Offset(horizontal * length, 0), paint);
      canvas.drawLine(point, point + Offset(0, vertical * length), paint);
    }
  }

  void _drawCircuitRoutes(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _cyan.withOpacity(0.34)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    final routes = [
      [Offset(size.width * .18, size.height * .28), Offset(size.width * .36, size.height * .28), Offset(size.width * .42, size.height * .37)],
      [Offset(size.width * .82, size.height * .68), Offset(size.width * .64, size.height * .68), Offset(size.width * .58, size.height * .59)],
      [Offset(size.width * .22, size.height * .80), Offset(size.width * .35, size.height * .80), Offset(size.width * .40, size.height * .69)],
    ];
    for (final route in routes) {
      final path = Path()..moveTo(route.first.dx, route.first.dy);
      for (final point in route.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(path, paint);
      for (final point in route) {
        canvas.drawCircle(point, 3.2, Paint()..color = _cyan.withOpacity(0.85));
      }
    }
  }

  void _drawScanLines(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.035)
      ..strokeWidth = 1;
    for (double y = 6; y < size.height; y += 6) {
      canvas.drawLine(Offset.zero + Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawRivets(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFB7C3CE).withOpacity(0.45);
    for (var index = 0; index < 8; index++) {
      final y = size.height * (0.13 + index * 0.10);
      canvas.drawCircle(Offset(size.width * 0.075, y), 2.2, paint);
      canvas.drawCircle(Offset(size.width * 0.925, y), 2.2, paint);
    }
  }

  void _drawHexagon(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (var index = 0; index <= 6; index++) {
      final angle = pi / 3 * index + pi / 6;
      final point = center + Offset(cos(angle), sin(angle)) * radius;
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ArmorHudPainter oldDelegate) => false;
}
