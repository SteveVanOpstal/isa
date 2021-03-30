import 'package:flutter/material.dart';
import 'package:isa/widgets/color/colorButtonWidget.dart';

class ColorsDialogWidget extends StatelessWidget {
  final Function(Color) onPressed;
  final Color activeColor;

  ColorsDialogWidget({@required this.activeColor, this.onPressed});

  _colorButtons(BuildContext context) {
    final colors = [];
    for (var i = 0; i < 8; i++) {
      colors.add(ColorButtonWidget(
        onPressed: (color) {
          Navigator.pop(context, true);
          this.onPressed(color);
        },
      ));
    }
    return colors;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(children: [
      Container(
        width: 300,
        height: 340,
        padding: EdgeInsets.all(10.0),
        child: GridView.count(
          crossAxisCount: 3,
          children: [
            Container(
              margin: EdgeInsets.all(5.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: activeColor,
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Icon(Icons.check),
              ),
            ),
            ..._colorButtons(context)
          ],
        ),
      ),
    ]);
  }
}
