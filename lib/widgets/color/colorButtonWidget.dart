import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class ColorButtonWidget extends StatelessWidget {
  final Color color;
  final Function(Color) onInit;
  final Function(Color) onPressed;
  final RandomColor _randomColor = RandomColor();

  ColorButtonWidget({@required this.onPressed, this.color, this.onInit});

  @override
  Widget build(BuildContext context) {
    var _color = this.color ??
        _randomColor.randomColor(
            colorSaturation: ColorSaturation.lowSaturation,
            colorBrightness: ColorBrightness.light);
    return Container(
      margin: EdgeInsets.only(left: 10.0, bottom: 10.0),
      width: 40.0,
      height: 40.0,
      child: RaisedButton(
        color: _color,
        onPressed: () {
          onPressed(_color);
        },
      ),
    );
  }
}
