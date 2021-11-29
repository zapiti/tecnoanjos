import 'dart:math';

import 'package:flutter/material.dart';

class SemiCircle extends StatelessWidget {
  final double diameter;
  final Color color;

  const SemiCircle({Key key, this.diameter = 200, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MyPainter(color),
      size: Size(diameter, diameter),
    );
  }
}

// This is the Painter class
class _MyPainter extends CustomPainter {
  final Color color;
  _MyPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      4.713,
      pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

Widget semiCircleWidget(double height, Color color, {Widget child}) {
  return Container(
      child: Stack(children: <Widget>[
    Container(
        margin: EdgeInsets.only(right: 20),
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: height / 2),
              color: color,
              height: height,
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  child: SemiCircle(
                    color: color,
                    diameter: height,
                  ),
                )),
          ],
        )),
    child ?? SizedBox(),
  ]));
}
