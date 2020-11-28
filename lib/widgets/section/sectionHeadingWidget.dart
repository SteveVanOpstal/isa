import 'package:flutter/material.dart';
import 'package:isa/models/section.dart';
import 'package:isa/widgets/color/colorLensMenuButton.dart';

class SectionHeadingWidget extends StatefulWidget {
  final Section section;
  final double width;
  final double height;

  const SectionHeadingWidget(
      {@required this.section, @required this.width, @required this.height});

  @override
  _SectionHeadingWidgetState createState() => _SectionHeadingWidgetState();
}

class _SectionHeadingWidgetState extends State<SectionHeadingWidget> {
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
            child: Text(widget.section.title),
          ),
          Container(
            alignment: Alignment.topRight,
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  color: Colors.white,
                  alignment: Alignment.center,
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      widget.section.addNote();
                    });
                  },
                ),
                ColorLensMenuButton(section: widget.section),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
