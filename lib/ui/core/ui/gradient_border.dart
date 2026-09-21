import 'package:material_ui/material_ui.dart';

class GradientBorder extends BoxBorder {
  const GradientBorder({required this.gradient, required this.width});

  final Gradient gradient;
  final double width;

  @override
  BorderSide get bottom => BorderSide.none;

  @override
  BorderSide get top => BorderSide.none;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  bool get isUniform => true;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    final paint = Paint()
      ..strokeWidth = width
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke;

    switch (shape) {
      case BoxShape.circle:
        final radius = (rect.shortestSide - width) / 2.0;
        canvas.drawCircle(rect.center, radius, paint);
      case BoxShape.rectangle:
        if (borderRadius != null) {
          canvas.drawRRect(
            borderRadius.toRRect(rect).deflate(width / 2),
            paint,
          );
          return;
        }
        canvas.drawRect(rect.deflate(width / 2), paint);
    }
  }

  @override
  ShapeBorder scale(double t) => this;
}
