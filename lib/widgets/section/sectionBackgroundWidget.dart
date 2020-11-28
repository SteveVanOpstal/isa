import 'package:flutter/material.dart';
import 'package:isa/models/section.dart';
import 'package:provider/provider.dart';

class SectionBackgroundWidget extends StatelessWidget {
  final Section section;
  final double minWidth;

  const SectionBackgroundWidget(this.section, {this.minWidth = 0});

  double _width(Section section) {
    var sectionWidth = section.width * section.scale;
    return sectionWidth < minWidth ? minWidth : sectionWidth;
  }

  double _height(Section section) {
    return section.height * section.scale;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Section>(
      builder: (context, section, child) {
        return Container(
          margin: EdgeInsets.fromLTRB(5.0, 5.0, 2.5, 2.5),
          child: Ink(
            color: section.color,
            child: SizedBox(
              width: _width(section) - 7.5,
              height: _height(section) - 7.5,
            ),
          ),
        );
      },
    );
  }
}
