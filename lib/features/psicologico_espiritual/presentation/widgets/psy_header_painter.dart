// lib/features/psicologico_espiritual/presentation/widgets/psy_header_painter.dart

import 'package:flutter/material.dart';

class PsyHeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final Gradient gradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF94C0FF), Color(0xFFFFFFFF)],
      stops: [0.0, 1.0],
    );

    final paint = Paint()..shader = gradient.createShader(rect);

    final path = Path();
    path.lineTo(0, size.height - 50);

    final controlPoint = Offset(size.width / 2, size.height);
    final endPoint = Offset(size.width, size.height - 50);

    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => false;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
