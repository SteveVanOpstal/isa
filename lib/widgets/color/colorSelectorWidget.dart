import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:isa/widgets/color/colorButtonWidget.dart';

class ColorSelectorWidget extends StatefulWidget {
  final color;
  final Function(Color) onColorChange;

  const ColorSelectorWidget(this.color, this.onColorChange);

  @override
  _ColorSelectorWidgetState createState() => _ColorSelectorWidgetState();
}

class _ColorSelectorWidgetState extends State<ColorSelectorWidget> {
  @override
  Widget build(BuildContext context) {
    var children = [];
    for (var i = 0; i < 18; i++) {
      children.add(
        ColorButtonWidget(
          onPressed: (color) {
            widget.onColorChange(color);
            Navigator.pop(context);
          },
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 6,
      children: children,
    );
  }
}
