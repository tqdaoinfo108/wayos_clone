import 'package:flutter/material.dart';

class ProcedureStepPainter extends CustomPainter {
  final String title;
  final String name;
  final String time;
  final Color pipelineColor;
  final Color backgroundColor;
  final IconData icon;
  final bool isLastStep;
  final TextPainter contentPainter;

  ProcedureStepPainter({
    super.repaint,
    required this.title,
    required this.name,
    required this.time,
    required this.pipelineColor,
    required this.backgroundColor,
    required this.icon,
    required this.contentPainter,
    this.isLastStep = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundIconPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final roundRectanglePaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final pipelinePaint = Paint()
      ..color = pipelineColor
      ..style = PaintingStyle.fill;

    double x = 12; // position x of background circle
    double y = 22; // position y of background circle
    // y = 22:

    // do not draw pipeline if it is last step
    if (!isLastStep) {
      // draw pipeline
      final pipeline = Rect.fromLTWH(x, (y + x) / 2, size.width, 10);
      canvas.drawRect(pipeline, pipelinePaint);
    }

    // draw checkbox icon
    TextPainter iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: 24,
          fontFamily: icon.fontFamily,
          fontWeight: FontWeight.bold,
          package: icon.fontPackage,
          color: backgroundColor,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    iconPainter.layout();
    // draw background circle
    canvas.drawCircle(Offset(x, y), y - x, backgroundIconPaint);
    iconPainter.paint(canvas, const Offset(0, 10));

    // draw round rectangle background
    final contentRect = Rect.fromLTWH(
        10, 45, contentPainter.width + 10, contentPainter.height + 10);
    canvas.drawRRect(RRect.fromRectAndRadius(contentRect, Radius.circular(5)),
        roundRectanglePaint);

    // draw content text
    double contentPadding = 5;
    contentPainter.paint(
        canvas,
        Offset(contentRect.left + contentPadding,
            contentRect.top + contentPadding));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
