import 'package:flutter/material.dart';
import '../../../../../../model/workflow_approval_status_item.dart';

class ProcedureStepPainter extends CustomPainter {
  final TextPainter contentPainter;
  final WorkflowApprovalStatusItem step;
  final bool isLastStep;

  ProcedureStepPainter({
    super.repaint,
    required this.contentPainter,
    required this.step,
    this.isLastStep = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double x = 12; // position x of background circle
    double y = 22; // position y of background circle

    // do not draw pipeline if it is last step
    if (!isLastStep) {
      // draw pipeline
      final pipeline = Rect.fromLTWH(x, (y + x) / 2, size.width, 10);
      canvas.drawRect(pipeline, getPaint(step.pipelineColor));
    }

    // draw checkbox icon
    if (step.statusText == 'Trạng Thái | Đang chờ duyệt') {
      const radiusList = [10.0, 5.5, 4.5, 2.0];
      for (var i = 0; i < radiusList.length; i++) {
        canvas.drawCircle(Offset(x, y), radiusList[i],
            getPaint(i % 2 == 0 ? step.backgroundColor : Colors.white));
      }
    } else {
      IconData icon = step.icon;
      TextPainter iconPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(icon.codePoint),
          style: TextStyle(
            fontSize: 24,
            fontFamily: icon.fontFamily,
            fontWeight: FontWeight.bold,
            package: icon.fontPackage,
            color: step.backgroundColor,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      iconPainter.layout();
      // draw background circle
      canvas.drawCircle(Offset(x, y), y - x, getPaint(Colors.white));
      iconPainter.paint(canvas, Offset(0, 10));
    }

    // draw round rectangle background
    final contentRect = Rect.fromLTWH(
        10, 45, contentPainter.width + 12, contentPainter.height + 12);
    canvas.drawRRect(RRect.fromRectAndRadius(contentRect, Radius.circular(5)),
        getPaint(step.backgroundColor));

    // draw content text
    double contentPadding = 6;
    contentPainter.paint(
        canvas,
        Offset(contentRect.left + contentPadding,
            contentRect.top + contentPadding));
  }

  Paint getPaint(Color color) {
    return Paint()
      ..color = color
      ..style = PaintingStyle.fill;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
