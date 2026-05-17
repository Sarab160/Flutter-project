import 'package:flutter/material.dart';

class GlowEffect extends StatelessWidget {
  final Color color;
  final double size;
  final double opacity;
  final double blurRadius;

  const GlowEffect({
    super.key,
    required this.color,
    this.size = 300,
    this.opacity = 0.15,
    this.blurRadius = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: opacity),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: opacity + 0.05),
            blurRadius: blurRadius,
          )
        ],
      ),
    );
  }
}

class ParticleBackground extends StatelessWidget {
  final Color? color;
  final double spacing;
  final double particleSize;

  const ParticleBackground({
    super.key,
    this.color,
    this.spacing = 70.0,
    this.particleSize = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? Theme.of(context).colorScheme.primary;
    return CustomPaint(
      painter: ParticlePainter(
        color: activeColor,
        spacing: spacing,
        particleSize: particleSize,
      ),
      child: Container(),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final Color color;
  final double spacing;
  final double particleSize;

  ParticlePainter({
    required this.color,
    required this.spacing,
    required this.particleSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: 0.08);

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), particleSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

