import 'package:flutter/material.dart';
import 'package:qr/qr.dart';
class QrImagePainter extends CustomPainter {
  final QrImage qrImage;
  QrImagePainter(this.qrImage);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final moduleSize = size.width / qrImage.moduleCount;

    for (var r = 0; r < qrImage.moduleCount; r++) {
      for (var c = 0; c < qrImage.moduleCount; c++) {
        if (qrImage.isDark(r, c)) {
          canvas.drawRect(
            Rect.fromLTWH(c * moduleSize, r * moduleSize, moduleSize, moduleSize),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
