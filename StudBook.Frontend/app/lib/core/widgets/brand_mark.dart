import 'package:flutter/material.dart';

import '../theme/tokens/app_dimens.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = AppSizes.iconLarge, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _HorseshoePainter(color ?? Theme.of(context).colorScheme.primary),
    );
  }
}

class _HorseshoePainter extends CustomPainter {
  _HorseshoePainter(this.color);

  static const _viewBox = 24.0;
  static const _stroke = 2.5;
  static const _armLeft = 6.0;
  static const _armRight = 18.0;
  static const _top = 3.0;
  static const _bendStart = 11.0;
  static const _radius = 6.0;
  static const _heelInset = 1.5;

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / _viewBox;
    canvas.scale(scale);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final shoe = Path()
      ..moveTo(_armLeft, _top)
      ..lineTo(_armLeft, _bendStart)
      ..arcToPoint(
        const Offset(_armRight, _bendStart),
        radius: const Radius.circular(_radius),
        clockwise: false,
      )
      ..lineTo(_armRight, _top);
    canvas.drawPath(shoe, paint);
    canvas.drawLine(
      const Offset(_armLeft - _heelInset, _top),
      const Offset(_armLeft + _heelInset, _top),
      paint,
    );
    canvas.drawLine(
      const Offset(_armRight - _heelInset, _top),
      const Offset(_armRight + _heelInset, _top),
      paint,
    );
  }

  @override
  bool shouldRepaint(_HorseshoePainter oldDelegate) => oldDelegate.color != color;
}
