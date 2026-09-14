import 'package:flutter/material.dart';

class TechDownloadProgress extends StatefulWidget {
  const TechDownloadProgress({
    super.key,
    required this.progress,
    required this.status,
    required this.showRetry,
    required this.onRetry,
  });

  final double progress;
  final String status;
  final bool showRetry;
  final VoidCallback onRetry;

  @override
  State<TechDownloadProgress> createState() => _TechDownloadProgressState();
}

class _TechDownloadProgressState extends State<TechDownloadProgress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double get _progress => widget.progress.clamp(0.0, 1.0).toDouble();

  @override
  Widget build(BuildContext context) {
    final percent = (_progress * 100).round();
    final isComplete = _progress >= 1.0;
    final accent = widget.showRetry ? const Color(0xFFFF5C8A) : const Color(0xFF55E6FF);

    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF061321), Color(0xFF101331), Color(0xFF190D2D)],
            ),
          ),
        ),
        CustomPaint(painter: _GridPainter(animation: _animationController)),
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Container(
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
                decoration: BoxDecoration(
                  color: const Color(0xDD081522),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: accent.withOpacity(0.55)),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withOpacity(0.18),
                      blurRadius: 34,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.radar_rounded, color: accent, size: 21),
                        const SizedBox(width: 9),
                        Text(
                          'DATA SYNC',
                          style: TextStyle(
                            color: accent,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2.4,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '01 / 01',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.45),
                            fontSize: 11,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    SizedBox(
                      height: 178,
                      width: 178,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          RotationTransition(
                            turns: _animationController,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: accent.withOpacity(0.28),
                                  width: 1,
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(13),
                                child: CircularProgressIndicator(
                                  value: 1,
                                  strokeWidth: 1,
                                  color: Color(0x4455E6FF),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 145,
                            width: 145,
                            child: CircularProgressIndicator(
                              value: _progress,
                              strokeWidth: 8,
                              strokeCap: StrokeCap.round,
                              backgroundColor: Colors.white.withOpacity(0.08),
                              valueColor: AlwaysStoppedAnimation<Color>(accent),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$percent%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 31,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                              Text(
                                isComplete ? 'READY' : 'DOWNLOADING',
                                style: TextStyle(
                                  color: accent,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.8,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      widget.status,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 17),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        children: [
                          Container(
                            height: 9,
                            color: Colors.white.withOpacity(0.09),
                          ),
                          FractionallySizedBox(
                            widthFactor: _progress,
                            child: Container(
                              height: 9,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [accent, const Color(0xFF9B7BFF)],
                                ),
                                boxShadow: [
                                  BoxShadow(color: accent, blurRadius: 9),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        Text(
                          'OFFLINE MAP',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.45),
                            fontSize: 10,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          widget.showRetry ? 'CONNECTION LOST' : 'INITIALIZING',
                          style: TextStyle(
                            color: accent,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                    if (widget.showRetry) ...[
                      const SizedBox(height: 23),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: widget.onRetry,
                          icon: const Icon(Icons.refresh_rounded, size: 18),
                          label: const Text('重新連線'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: accent,
                            side: BorderSide(color: accent.withOpacity(0.7)),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter({required this.animation}) : super(repaint: animation);

  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x1855E6FF)
      ..strokeWidth = 0.6;
    const gap = 34.0;
    final offset = animation.value * gap;

    for (double x = -gap + offset; x < size.width + gap; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = -gap + offset; y < size.height + gap; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) => false;
}
