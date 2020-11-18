import 'package:flutter/material.dart';

class SectionHeadingWidget extends StatefulWidget {
  final double width;
  final double height;
  final String title;
  final VoidCallback onAdd;

  const SectionHeadingWidget(
      {@required this.width,
      @required this.height,
      @required this.title,
      this.onAdd});

  @override
  _SectionHeadingWidgetState createState() => _SectionHeadingWidgetState();
}

class _SectionHeadingWidgetState extends State<SectionHeadingWidget> {
  add() {
    widget.onAdd();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.all(10.0),
            child: Text(widget.title),
          ),
          Container(
            alignment: Alignment.topRight,
            padding: EdgeInsets.all(10.0),
            child: IconButton(
              alignment: Alignment.center,
              icon: Icon(Icons.add),
              onPressed: () {
                add();
              },
            ),
          ),
        ],
      ),
    );
  }
}
