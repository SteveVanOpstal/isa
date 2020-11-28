import 'package:flutter/material.dart';
import 'package:isa/models/section.dart';
import 'package:isa/widgets/color/colorButtonWidget.dart';

class _ColorDialogWidget extends StatelessWidget {
  final double top;
  final double left;
  final Section section;

  _ColorDialogWidget({@required this.section, this.top, this.left});

  _colorWidgets(context, count) {
    List<Widget> colorWidgets = [];
    for (var i = 0; i < count; i++) {
      colorWidgets.add(ColorButtonWidget(
        onPressed: (color) {
          section.setColor(color);
          Navigator.pop(context);
        },
      ));
    }
    return colorWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      height: 150.0,
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ..._colorWidgets(context, 2),
          Container(
            margin: EdgeInsets.only(left: 10.0, bottom: 10.0),
            width: 40.0,
            height: 40.0,
            child: IconButton(
              color: Colors.white,
              icon: Icon(Icons.color_lens),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          ..._colorWidgets(context, 6),
        ],
      ),
    );
  }
}

class ColorLensMenuButton extends StatelessWidget {
  final Section section;

  ColorLensMenuButton({@required this.section});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.white,
      alignment: Alignment.center,
      icon: Icon(Icons.color_lens),
      onPressed: () {
        final RenderBox button = context.findRenderObject() as RenderBox;
        final position =
            button.localToGlobal(button.size.topRight(Offset(-150.0, 0.0)));

        showDialog(
            context: context,
            barrierColor: Colors.white.withOpacity(0),
            builder: (context) {
              return Material(
                type: MaterialType.transparency,
                child: Stack(
                  children: [
                    Positioned(
                      left: position.dx,
                      top: position.dy,
                      child: _ColorDialogWidget(section: section),
                    ),
                  ],
                ),
              );
            });
      },
    );
  }
}
