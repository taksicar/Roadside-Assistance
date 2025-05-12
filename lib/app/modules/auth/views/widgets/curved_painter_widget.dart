import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CurvedPainter extends CustomPainter {
  final Color color;

  CurvedPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.05,
        size.height * 0.55,
        size.width * 0.4,
        size.height * 0.55,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.55,
        size.width,
        0,
      )
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
